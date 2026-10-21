/**
 * Realtime events over a WebSocket.
 *
 * ---
 * auto realtime = new Realtime(client);
 * auto subscription = realtime.subscribe(
 *     Channel.tablesdb("main").table("todos").row().toString(),
 *     (RealtimeMessage message) {
 *         writeln(message.events, " ", message.payload);
 *     });
 * // later
 * subscription.unsubscribe();
 * ---
 *
 * The connection runs on a background thread, opens when the first
 * subscription is made, reconnects with back-off when it drops, and closes when
 * `disconnect` is called. Callbacks are delivered through the client's
 * `Dispatcher` (see `appwrite.async`); with the default dispatcher they run on
 * the realtime thread.
 */
module appwrite.realtime;

import core.sync.mutex : Mutex;
import core.thread : Thread;
import core.time : Duration, MonoTime, msecs, seconds;
import std.json;
import std.uri : encodeComponent;

import appwrite.async;
import appwrite.client;
import appwrite.exception;
import appwrite.json : deserialize;
import appwrite.websocket;

/// An event received on a subscription.
struct RealtimeMessage
{
    /// Every form of the event name, most specific first, e.g. `tablesdb.main.tables.todos.rows.*.create`.
    string[] events;
    /// The resource the event is about, e.g. the row that was created.
    JSONValue payload;
    /// Channels the event matched.
    string[] channels;
    /// When the event happened (ISO 8601, UTC).
    string timestamp;
    /// IDs of the subscriptions the event was delivered to.
    string[] subscriptions;

    /// Convert the payload to a model, e.g. `message.payloadAs!(models.Row)`.
    T payloadAs(T)() const
    {
        return deserialize!T(cast(JSONValue) payload);
    }
}

/// Receives events for a subscription.
alias RealtimeCallback = void delegate(RealtimeMessage message);

/// Receives errors from the realtime connection.
alias RealtimeErrorCallback = void delegate(AppwriteException error);

/// One subscription made with `Realtime.subscribe`.
final class RealtimeSubscription
{
    private Realtime realtime;
    private string _id;
    private string[] _channels;
    private string[] _queries;
    private RealtimeCallback callback;

    private this(Realtime realtime, string id, string[] channels, string[] queries, RealtimeCallback callback)
    {
        this.realtime = realtime;
        _id = id;
        _channels = channels;
        _queries = queries;
        this.callback = callback;
    }

    /// The subscription's ID, as listed in `RealtimeMessage.subscriptions`.
    string id() const
    {
        return _id;
    }

    /// The channels this subscription listens to.
    string[] channels()
    {
        synchronized (realtime.lock)
            return _channels.dup;
    }

    /// The queries filtering this subscription's events.
    string[] queries()
    {
        synchronized (realtime.lock)
            return _queries.dup;
    }

    /// Stop receiving events. Other subscriptions keep the connection open.
    void unsubscribe()
    {
        realtime.remove(this, false);
    }

    /// Replace the channels and/or queries without creating a new subscription.
    void update(string[] channels = null, string[] queries = null)
    {
        realtime.change(this, channels, queries);
    }

    /// Unsubscribe, and close the connection if this was the last subscription.
    void close()
    {
        realtime.remove(this, true);
    }
}

/// The realtime connection. See the module documentation.
final class Realtime
{
    private Client client;
    private Dispatcher dispatcher;
    private Mutex lock;
    private RealtimeSubscription[string] subscriptions;
    private bool[string] pendingSubscribes;
    private string[] pendingUnsubscribes;
    private JSONValue pendingPresence;
    private bool presenceDirty;
    private RealtimeErrorCallback[] errorCallbacks;
    private Thread worker;
    private bool stopping;
    private bool appConnected;

    /// Heartbeat interval; the server drops connections that stay silent too long.
    Duration heartbeat = 20.seconds;

    this(Client client, Dispatcher dispatcher = null)
    {
        this.client = client;
        this.dispatcher = dispatcher;
        lock = new Mutex;
    }

    /**
     * Listen to `channels`, calling `callback` for each event. `queries`
     * filter which events are delivered, e.g. `[Query.equal("status", "done")]`.
     */
    RealtimeSubscription subscribe(string[] channels, RealtimeCallback callback, string[] queries = null)
    {
        if (channels.length == 0)
            throw new AppwriteException("At least one channel is required");
        RealtimeSubscription subscription;
        synchronized (lock)
        {
            auto id = uniqueId();
            while (id in subscriptions)
                id = uniqueId();
            subscription = new RealtimeSubscription(this, id, channels.dup, queries.dup, callback);
            subscriptions[id] = subscription;
            pendingSubscribes[id] = true;
        }
        ensureRunning();
        return subscription;
    }

    /// Listen to one channel.
    RealtimeSubscription subscribe(string channel, RealtimeCallback callback, string[] queries = null)
    {
        return subscribe([channel], callback, queries);
    }

    /**
     * Publish the current user's presence. The latest value is sent as soon as
     * the connection is up and again after every reconnect.
     */
    void upsertPresence(string status, string presenceId, string[] permissions = null,
        JSONValue metadata = JSONValue.init)
    {
        JSONValue[string] data = [
            "status": JSONValue(status),
            "presenceId": JSONValue(presenceId),
        ];
        if (permissions !is null)
            data["permissions"] = JSONValue(permissions);
        if (metadata.type != JSONType.null_)
            data["metadata"] = metadata;
        synchronized (lock)
        {
            pendingPresence = JSONValue(data);
            presenceDirty = true;
        }
        ensureRunning();
    }

    /// Be told when the connection reports an error.
    void onError(RealtimeErrorCallback callback)
    {
        synchronized (lock)
            errorCallbacks ~= callback;
    }

    /// Whether the connection is open and authenticated with the server.
    bool isConnected()
    {
        synchronized (lock)
            return appConnected;
    }

    /// Close the connection and drop every subscription.
    void disconnect()
    {
        Thread running;
        synchronized (lock)
        {
            subscriptions = null;
            pendingSubscribes = null;
            pendingUnsubscribes = null;
            pendingPresence = JSONValue.init;
            presenceDirty = false;
            stopping = true;
            running = worker;
        }
        if (running !is null && running !is Thread.getThis())
            running.join(false);
        synchronized (lock)
        {
            worker = null;
            stopping = false;
            appConnected = false;
        }
    }

    private void remove(RealtimeSubscription subscription, bool closeIfLast)
    {
        bool last;
        synchronized (lock)
        {
            if (subscription.id !in subscriptions)
                return;
            subscriptions.remove(subscription.id);
            pendingSubscribes.remove(subscription.id);
            pendingUnsubscribes ~= subscription.id;
            last = subscriptions.length == 0 && pendingPresence.type == JSONType.null_;
        }
        if (closeIfLast && last)
            disconnect();
    }

    private void change(RealtimeSubscription subscription, string[] channels, string[] queries)
    {
        synchronized (lock)
        {
            if (subscription.id !in subscriptions)
                return;
            if (channels !is null)
                subscription._channels = channels.dup;
            if (queries !is null)
                subscription._queries = queries.dup;
            pendingSubscribes[subscription.id] = true;
        }
        ensureRunning();
    }

    private void ensureRunning()
    {
        synchronized (lock)
        {
            if (worker !is null && worker.isRunning)
                return;
            stopping = false;
            worker = new Thread(&run);
            worker.isDaemon = true;
            worker.start();
        }
    }

    private bool hasWork()
    {
        synchronized (lock)
            return !stopping && (subscriptions.length > 0 || pendingPresence.type != JSONType.null_);
    }

    private bool shouldStop()
    {
        synchronized (lock)
            return stopping;
    }

    private void run()
    {
        int retries;
        while (hasWork())
        {
            WebSocket socket;
            try
            {
                socket = connect();
                retries = 0;
                serve(socket);
                if (shouldStop() || !hasWork())
                {
                    socket.close(1000, "Ending session");
                    break;
                }
            }
            catch (StopReconnecting)
            {
                if (socket !is null)
                    socket.close();
                break;
            }
            catch (Exception e)
            {
                if (socket !is null)
                    socket.close();
                if (shouldStop())
                    break;
                reportError(cast(AppwriteException) e !is null
                        ? cast(AppwriteException) e : new AppwriteException(e.msg));
            }
            synchronized (lock)
                appConnected = false;
            if (!sleepUnlessStopped(backoff(retries++)))
                break;
        }
        synchronized (lock)
        {
            appConnected = false;
            if (worker is Thread.getThis())
                worker = null;
        }
    }

    private WebSocket connect()
    {
        auto endpoint = client.endpointRealtime;
        auto project = client.config("project");
        auto url = endpoint ~ "/realtime?project=" ~ encodeComponent(project);

        string[string] headers;
        auto host = hostOf(endpoint);
        auto cookie = client.cookies.headerFor(host, pathOfUrl(endpoint) ~ "/realtime",
            endpoint.length >= 4 && endpoint[0 .. 4] == "wss:");
        if (cookie.length)
            headers["Cookie"] = cookie;
        auto jwt = client.config("jwt");
        if (jwt.length)
            headers["X-Appwrite-JWT"] = jwt;
        foreach (key, value; client.getHeaders())
            if (key == "Origin" || key == "origin" || key == "User-Agent" || key == "user-agent")
                headers[key] = value;

        return new WebSocket(url, headers, client.selfSigned);
    }

    private void serve(WebSocket socket)
    {
        auto lastPing = MonoTime.currTime;
        while (true)
        {
            if (shouldStop() || !hasWork())
                return;
            flush(socket);
            if (isConnected() && MonoTime.currTime - lastPing >= heartbeat)
            {
                socket.sendText(`{"type":"ping"}`);
                lastPing = MonoTime.currTime;
            }
            WebSocketMessage message;
            if (!socket.receive(message, 100))
                continue;
            final switch (message.kind)
            {
            case WebSocketMessage.Kind.close:
                if (message.closeCode == 1008)
                {
                    reportError(new AppwriteException(message.text.length ? message.text : "Policy violation", 1008));
                    throw new StopReconnecting;
                }
                throw new AppwriteException("The realtime server closed the connection", message.closeCode);
            case WebSocketMessage.Kind.binary:
                break;
            case WebSocketMessage.Kind.text:
                handle(socket, message.text);
                break;
            }
        }
    }

    private void handle(WebSocket socket, string text)
    {
        JSONValue json;
        try
            json = parseJSON(text);
        catch (JSONException)
            return;
        if (json.type != JSONType.object)
            return;
        auto type = "type" in json;
        auto data = "data" in json;
        if (type is null || type.type != JSONType.string)
            return;

        switch (type.str)
        {
        case "connected":
            bool anonymous = data is null || data.type != JSONType.object
                || "user" !in *data || (*data)["user"].type != JSONType.object
                || (*data)["user"].object.length == 0;
            if (anonymous)
            {
                auto session = sessionCookie();
                if (session.length)
                    socket.sendText(JSONValue([
                        "type": JSONValue("authentication"),
                        "data": JSONValue(["session": JSONValue(session)]),
                    ]).toString());
            }
            synchronized (lock)
            {
                foreach (id; subscriptions.keys)
                    pendingSubscribes[id] = true;
                pendingUnsubscribes = null;
                if (pendingPresence.type != JSONType.null_)
                    presenceDirty = true;
                appConnected = true;
            }
            flush(socket);
            break;
        case "event":
            if (data is null || data.type != JSONType.object)
                return;
            auto message = deserialize!RealtimeMessage(*data);
            RealtimeCallback[] callbacks;
            synchronized (lock)
                foreach (id; message.subscriptions)
                    if (auto subscription = id in subscriptions)
                        callbacks ~= (*subscription).callback;
            foreach (callback; callbacks)
                deliver(bindMessage(callback, message));
            break;
        case "error":
            string errorMessage = "Realtime error";
            int code;
            if (data !is null && data.type == JSONType.object)
            {
                if (auto m = "message" in *data)
                    if (m.type == JSONType.string)
                        errorMessage = m.str;
                if (auto c = "code" in *data)
                    code = cast(int) deserialize!long(*c);
            }
            reportError(new AppwriteException(errorMessage, code, null, text));
            break;
        default: // pong, response
            break;
        }
    }

    /// Send queued subscribe, unsubscribe and presence frames once the server has said hello.
    private void flush(WebSocket socket)
    {
        JSONValue[] subscribeRows;
        JSONValue[] unsubscribeRows;
        JSONValue presence;
        synchronized (lock)
        {
            // Frames sent before the `connected` event make Appwrite close the socket.
            if (!appConnected)
                return;
            foreach (id; pendingSubscribes.keys)
                if (auto subscription = id in subscriptions)
                    subscribeRows ~= JSONValue([
                        "subscriptionId": JSONValue(id),
                        "channels": JSONValue((*subscription)._channels),
                        "queries": JSONValue((*subscription)._queries),
                    ]);
            pendingSubscribes = null;
            foreach (id; pendingUnsubscribes)
                unsubscribeRows ~= JSONValue(["subscriptionId": JSONValue(id)]);
            pendingUnsubscribes = null;
            if (presenceDirty)
            {
                presence = pendingPresence;
                presenceDirty = false;
            }
        }
        if (unsubscribeRows.length)
            socket.sendText(JSONValue(["type": JSONValue("unsubscribe"), "data": JSONValue(unsubscribeRows)]).toString());
        if (subscribeRows.length)
            socket.sendText(JSONValue(["type": JSONValue("subscribe"), "data": JSONValue(subscribeRows)]).toString());
        if (presence.type != JSONType.null_)
            socket.sendText(JSONValue(["type": JSONValue("presence"), "data": presence]).toString());
    }

    private string sessionCookie()
    {
        auto host = hostOf(client.endpoint);
        auto project = client.config("project");
        auto session = client.cookies.get("a_session_" ~ project, host);
        if (session is null)
            session = client.cookies.get("a_session_" ~ project ~ "_legacy", host);
        return session;
    }

    private void reportError(AppwriteException error)
    {
        RealtimeErrorCallback[] callbacks;
        synchronized (lock)
            callbacks = errorCallbacks.dup;
        foreach (callback; callbacks)
            deliver(bindError(callback, error));
    }

    private void deliver(void delegate() task)
    {
        auto target = dispatcher is null ? getDefaultDispatcher() : dispatcher;
        try
            target.post(task);
        catch (Exception)
        {
            // A failing callback must not take the connection down.
        }
    }

    private bool sleepUnlessStopped(Duration duration)
    {
        auto deadline = MonoTime.currTime + duration;
        while (MonoTime.currTime < deadline)
        {
            if (shouldStop() || !hasWork())
                return false;
            Thread.sleep(50.msecs);
        }
        return !shouldStop();
    }

    private static Duration backoff(int retries)
    {
        if (retries < 5)
            return 1.seconds;
        if (retries < 15)
            return 5.seconds;
        if (retries < 100)
            return 10.seconds;
        return 60.seconds;
    }

    private static string uniqueId()
    {
        import appwrite.id : ID;

        return ID.unique();
    }
}

// Each call makes its own closure; a lambda written inside the foreach would share one.
private void delegate() bindMessage(RealtimeCallback callback, RealtimeMessage message)
{
    return () => callback(message);
}

private void delegate() bindError(RealtimeErrorCallback callback, AppwriteException error)
{
    return () => callback(error);
}

private class StopReconnecting : Exception
{
    this()
    {
        super("stop");
    }
}

private string pathOfUrl(string url)
{
    import std.string : indexOf;

    auto scheme = url.indexOf("://");
    auto rest = scheme >= 0 ? url[scheme + 3 .. $] : url;
    auto slash = rest.indexOf('/');
    return slash < 0 ? "" : rest[slash .. $];
}

