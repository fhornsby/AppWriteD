/**
 * A minimal RFC 6455 WebSocket client, used by `appwrite.realtime`.
 *
 * It speaks the WebSocket protocol over a `CurlConnection`, so wss://, proxies
 * and the system certificate store all behave as they do for API requests.
 */
module appwrite.websocket;

import std.array : appender;
import std.base64 : Base64;
import std.conv : to;
import std.digest.sha : sha1Of;
import std.random : uniform;
import std.string : indexOf, startsWith, strip, toLower;

import appwrite.curl;
import appwrite.exception;

/// A complete message received from the server.
struct WebSocketMessage
{
    enum Kind
    {
        text,
        binary,
        close,
    }

    Kind kind;
    ubyte[] data;
    /// Close status code, for `Kind.close`.
    ushort closeCode;

    string text() const
    {
        return cast(string) data.idup;
    }
}

/// A WebSocket connection. Not thread-safe: use it from one thread.
final class WebSocket
{
    private CurlConnection connection;
    private ubyte[] buffer;
    private ubyte[] fragments;
    private WebSocketMessage.Kind fragmentKind;
    private bool open;

    /**
     * Connect to `url` (ws:// or wss://) and complete the opening handshake,
     * sending `headers` with the upgrade request.
     */
    this(string url, string[string] headers, bool insecure, long connectTimeoutMs = 30_000)
    {
        string httpUrl;
        if (url.startsWith("wss://"))
            httpUrl = "https://" ~ url[6 .. $];
        else if (url.startsWith("ws://"))
            httpUrl = "http://" ~ url[5 .. $];
        else
            throw new AppwriteException("Invalid realtime endpoint URL: " ~ url);

        auto rest = httpUrl[httpUrl.indexOf("://") + 3 .. $];
        auto slash = rest.indexOf('/');
        auto authority = slash < 0 ? rest : rest[0 .. slash];
        auto target = slash < 0 ? "/" : rest[slash .. $];

        connection = new CurlConnection(httpUrl, insecure, connectTimeoutMs);
        scope (failure)
            connection.close();

        ubyte[16] nonce;
        foreach (ref b; nonce)
            b = cast(ubyte) uniform(0, 256);
        auto key = Base64.encode(nonce[]).idup;

        auto request = appender!string;
        request.put("GET " ~ target ~ " HTTP/1.1\r\n");
        request.put("Host: " ~ authority ~ "\r\n");
        request.put("Upgrade: websocket\r\nConnection: Upgrade\r\n");
        request.put("Sec-WebSocket-Key: " ~ key ~ "\r\nSec-WebSocket-Version: 13\r\n");
        foreach (name, value; headers)
            if (value.length)
                request.put(name ~ ": " ~ value ~ "\r\n");
        request.put("\r\n");
        connection.send(cast(const(ubyte)[]) request.data);

        // Read the response head; anything after it is the first frame data.
        import core.time : MonoTime, msecs;

        auto deadline = MonoTime.currTime + connectTimeoutMs.msecs;
        ubyte[4096] chunk;
        ptrdiff_t end = -1;
        while (end < 0)
        {
            auto left = (deadline - MonoTime.currTime).total!"msecs";
            if (left <= 0)
                throw new AppwriteException("Timed out waiting for the realtime handshake");
            auto received = connection.receive(chunk[], cast(int) left);
            buffer ~= chunk[0 .. received];
            end = (cast(string) buffer).indexOf("\r\n\r\n");
            if (end < 0 && buffer.length > 65_536)
                throw new AppwriteException("Invalid realtime handshake response");
        }
        auto head = cast(string) buffer[0 .. end].idup;
        buffer = buffer[end + 4 .. $].dup;

        auto lines = head.splitLines();
        if (lines.length == 0 || lines[0].indexOf(" 101") < 0)
        {
            auto status = lines.length ? lines[0] : head;
            throw new AppwriteException("Realtime handshake failed: " ~ status, statusCode(status));
        }
        string accept;
        foreach (line; lines[1 .. $])
        {
            auto colon = line.indexOf(':');
            if (colon > 0 && line[0 .. colon].strip.toLower == "sec-websocket-accept")
                accept = line[colon + 1 .. $].strip;
        }
        auto expected = Base64.encode(sha1Of(key ~ "258EAFA5-E914-47DA-95CA-C5AB0DC85B11")[]).idup;
        if (accept != expected)
            throw new AppwriteException("Realtime handshake failed: bad Sec-WebSocket-Accept");
        open = true;
    }

    /// Whether the connection is open.
    bool isOpen() const
    {
        return open;
    }

    /// Send a text message.
    void sendText(string text)
    {
        sendFrame(0x1, cast(const(ubyte)[]) text);
    }

    /**
     * Wait up to `timeoutMs` for a complete message. Returns false on timeout.
     * Pings are answered automatically; a close frame is returned as a
     * `Kind.close` message and closes the connection.
     */
    bool receive(out WebSocketMessage message, int timeoutMs)
    {
        import core.time : MonoTime, msecs;

        auto deadline = MonoTime.currTime + timeoutMs.msecs;
        while (true)
        {
            if (parseFrame(message))
                return true;
            if (!open)
                throw new AppwriteException("The realtime connection is closed");
            auto left = (deadline - MonoTime.currTime).total!"msecs";
            if (left <= 0)
                return false;
            ubyte[16_384] chunk;
            auto received = connection.receive(chunk[], cast(int) left);
            if (received == 0)
                return false;
            buffer ~= chunk[0 .. received];
        }
    }

    /// Send a close frame and drop the connection.
    void close(ushort code = 1000, string reason = "")
    {
        if (open)
        {
            open = false;
            try
            {
                ubyte[] payload = [cast(ubyte)(code >> 8), cast(ubyte)(code & 0xff)];
                payload ~= cast(const(ubyte)[]) reason;
                sendFrame(0x8, payload, true);
            }
            catch (Exception)
            {
            }
        }
        connection.close();
    }

    private void sendFrame(ubyte opcode, const(ubyte)[] payload, bool force = false)
    {
        if (!open && !force)
            throw new AppwriteException("The realtime connection is closed");
        auto frame = appender!(ubyte[]);
        frame.put(cast(ubyte)(0x80 | opcode));
        if (payload.length < 126)
            frame.put(cast(ubyte)(0x80 | payload.length));
        else if (payload.length <= ushort.max)
        {
            frame.put(cast(ubyte)(0x80 | 126));
            frame.put(cast(ubyte)(payload.length >> 8));
            frame.put(cast(ubyte)(payload.length & 0xff));
        }
        else
        {
            frame.put(cast(ubyte)(0x80 | 127));
            foreach_reverse (i; 0 .. 8)
                frame.put(cast(ubyte)((cast(ulong) payload.length >> (i * 8)) & 0xff));
        }
        ubyte[4] mask;
        foreach (ref b; mask)
            b = cast(ubyte) uniform(0, 256);
        frame.put(mask[]);
        foreach (i, b; payload)
            frame.put(cast(ubyte)(b ^ mask[i % 4]));
        connection.send(frame.data);
    }

    /// Take one complete message off the buffer, handling control frames.
    private bool parseFrame(ref WebSocketMessage message)
    {
        while (true)
        {
            if (buffer.length < 2)
                return false;
            immutable fin = (buffer[0] & 0x80) != 0;
            immutable opcode = buffer[0] & 0x0f;
            immutable masked = (buffer[1] & 0x80) != 0;
            ulong length = buffer[1] & 0x7f;
            size_t offset = 2;
            if (length == 126)
            {
                if (buffer.length < 4)
                    return false;
                length = (cast(ulong) buffer[2] << 8) | buffer[3];
                offset = 4;
            }
            else if (length == 127)
            {
                if (buffer.length < 10)
                    return false;
                length = 0;
                foreach (i; 0 .. 8)
                    length = (length << 8) | buffer[2 + i];
                offset = 10;
            }
            ubyte[4] mask;
            if (masked)
            {
                if (buffer.length < offset + 4)
                    return false;
                mask[] = buffer[offset .. offset + 4];
                offset += 4;
            }
            if (buffer.length < offset + length)
                return false;

            auto payload = buffer[offset .. offset + cast(size_t) length].dup;
            if (masked)
                foreach (i, ref b; payload)
                    b ^= mask[i % 4];
            buffer = buffer[offset + cast(size_t) length .. $].dup;

            switch (opcode)
            {
            case 0x0: // continuation
                fragments ~= payload;
                if (fin)
                {
                    message = WebSocketMessage(fragmentKind, fragments);
                    fragments = null;
                    return true;
                }
                break;
            case 0x1:
            case 0x2:
                auto kind = opcode == 0x1 ? WebSocketMessage.Kind.text : WebSocketMessage.Kind.binary;
                if (fin)
                {
                    message = WebSocketMessage(kind, payload);
                    return true;
                }
                fragmentKind = kind;
                fragments = payload;
                break;
            case 0x8:
                ushort code = payload.length >= 2 ? cast(ushort)((payload[0] << 8) | payload[1]) : 1005;
                message = WebSocketMessage(WebSocketMessage.Kind.close, payload.length > 2 ? payload[2 .. $] : null, code);
                if (open)
                {
                    try
                        sendFrame(0x8, payload.length >= 2 ? payload[0 .. 2] : null);
                    catch (Exception)
                    {
                    }
                }
                open = false;
                connection.close();
                return true;
            case 0x9:
                sendFrame(0xA, payload);
                break;
            default: // pong and reserved opcodes
                break;
            }
        }
    }

    private static int statusCode(string statusLine)
    {
        import std.algorithm : splitter;

        auto parts = statusLine.splitter(' ');
        if (parts.empty)
            return 0;
        parts.popFront();
        if (parts.empty)
            return 0;
        try
            return parts.front.to!int;
        catch (Exception)
            return 0;
    }
}

private string[] splitLines(string text)
{
    import std.algorithm : map, splitter;
    import std.array : array;

    return text.splitter("\r\n").map!(line => line).array;
}

