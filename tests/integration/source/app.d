/**
 * Integration test against a real Appwrite server, as an end user would use
 * the SDK. tests/integration/run.sh starts a server in Docker and prepares the
 * project this expects: database `main` with table `todos` (columns `title`,
 * `done`; users may create rows) and bucket `files` (users may create files).
 *
 * Exits non-zero when any check fails.
 */
module app;

import core.sync.mutex : Mutex;
import core.thread : Thread;
import core.time : MonoTime, msecs, seconds, Duration;
import std.algorithm : any, canFind;
import std.conv : to;
import std.file : exists, mkdirRecurse, rmdirRecurse, tempDir;
import std.path : buildPath;
import std.process : environment;
import std.random : uniform;
import std.stdio : stdout, writeln;

import appwrite;

int failures;

void check(bool ok, string what)
{
    writeln(ok ? "PASS " : "FAIL ", what);
    stdout.flush();
    if (!ok)
        failures++;
}

/// Realtime events, collected for the main thread.
final class Events
{
    private Mutex lock;
    private RealtimeMessage[] received;

    this()
    {
        lock = new Mutex;
    }

    void add(RealtimeMessage message)
    {
        synchronized (lock)
            received ~= message;
    }

    /// Wait for an event whose name ends with `suffix`.
    bool waitFor(string suffix, Duration timeout, out RealtimeMessage found)
    {
        import std.algorithm : endsWith;

        auto deadline = MonoTime.currTime + timeout;
        while (MonoTime.currTime < deadline)
        {
            synchronized (lock)
                foreach (message; received)
                    if (message.events.any!(e => e.endsWith(suffix)))
                    {
                        found = message;
                        return true;
                    }
            Thread.sleep(50.msecs);
        }
        return false;
    }
}

struct Todo
{
    string title;
    bool done;
}

int main()
{
    auto endpoint = environment.get("APPWRITE_ENDPOINT", "http://localhost:9080/v1");
    auto realtimeEndpoint = environment.get("APPWRITE_REALTIME_ENDPOINT", "ws://localhost:9081/v1");
    auto project = environment.get("APPWRITE_PROJECT", "dtest");

    auto storeDir = buildPath(tempDir, "appwrited-integration-" ~ uniform(0, 1_000_000).to!string);
    mkdirRecurse(storeDir);
    scope (exit)
        rmdirRecurse(storeDir);
    auto sessionFile = buildPath(storeDir, "session.json");

    Client makeClient()
    {
        return new Client()
            .setEndpoint(endpoint)
            .setEndpointRealtime(realtimeEndpoint)
            .setProject(project)
            .setCookieStore(new FileCookieStore(sessionFile));
    }

    auto client = makeClient();
    auto account = new Account(client);
    auto tablesDB = new TablesDB(client);
    auto storage = new Storage(client);

    // Accounts and sessions
    auto email = "d-" ~ ID.unique() ~ "@example.com";
    enum password = "D-language-rocks-42";
    auto created = account.create(userId: ID.unique(), email: email, password: password, name: "D Tester");
    check(created.email == email && created.name == "D Tester", "account.create returns the new user");

    auto session = account.createEmailPasswordSession(email: email, password: password);
    check(session.userId == created.id && session.current, "createEmailPasswordSession creates the current session");
    check(client.cookies.get("a_session_" ~ project, hostOf(endpoint)) !is null, "the session cookie is stored");

    auto me = account.get();
    check(me.id == created.id, "account.get uses the session cookie");
    check(exists(sessionFile), "FileCookieStore wrote the session file");

    auto restarted = new Account(makeClient());
    check(restarted.get().id == created.id, "a new client with the same cookie store is still signed in");

    auto jwt = account.createJWT();
    auto jwtClient = new Client().setEndpoint(endpoint).setProject(project).setJWT(jwt.jwt);
    check(new Account(jwtClient).get().id == created.id, "a JWT authenticates another client");

    auto prefs = account.updatePrefs(prefs: parseJSON(`{"theme":"dark","fontSize":14}`));
    check(prefs.prefs["theme"].str == "dark", "updatePrefs round-trips custom preferences");

    // Realtime, authenticated by the session cookie
    auto realtime = new Realtime(client);
    auto events = new Events;
    AppwriteException realtimeError;
    realtime.onError((AppwriteException e) { realtimeError = e; });
    realtime.subscribe(Channel.tablesdb("main").table("todos").row(), &events.add);
    auto connectDeadline = MonoTime.currTime + 10.seconds;
    while (!realtime.isConnected && MonoTime.currTime < connectDeadline)
        Thread.sleep(50.msecs);
    check(realtime.isConnected, "realtime connects");
    Thread.sleep(1.seconds); // let the subscription reach the server

    // Rows
    auto userOnly = [
        Permission.read(Role.user(me.id)),
        Permission.update(Role.user(me.id)),
        Permission.delete_(Role.user(me.id)),
    ];
    auto row = tablesDB.createRow(databaseId: "main", tableId: "todos", rowId: ID.unique(),
        data: serialize(Todo("Write a D SDK", false)), permissions: userOnly);
    check(row["title"].str == "Write a D SDK" && row.tableId == "todos", "createRow returns the row with its columns");
    check(row.permissions.length == 3, "createRow keeps the permissions");

    RealtimeMessage event;
    auto gotCreate = events.waitFor(".create", 10.seconds, event);
    check(gotCreate && event.payloadAs!(models.Row).id == row.id, "realtime delivers the create event");
    if (realtimeError !is null)
        writeln("     realtime error: ", realtimeError.msg);

    tablesDB.createRow(databaseId: "main", tableId: "todos", rowId: ID.unique(),
        data: serialize(Todo("Ship it", true)), permissions: userOnly);
    auto open = tablesDB.listRows(databaseId: "main", tableId: "todos",
        queries: [Query.equal("done", false), Query.orderDesc("$createdAt"), Query.limit(10)]);
    check(open.total == 1 && open.rows[0].id == row.id, "listRows filters with Query.equal");
    check(open.rows[0].convertTo!Todo == Todo("Write a D SDK", false), "convertTo maps a row onto a struct");
    auto all = tablesDB.listRows(databaseId: "main", tableId: "todos", total: true.nullable);
    check(all.total == 2, "listRows counts every row the user can read");

    auto updated = tablesDB.updateRow(databaseId: "main", tableId: "todos", rowId: row.id,
        data: serialize(["done": true]));
    check(updated["done"].boolean, "updateRow changes a column");
    check(events.waitFor(".update", 10.seconds, event), "realtime delivers the update event");

    try
    {
        tablesDB.getRow(databaseId: "main", tableId: "todos", rowId: "does-not-exist");
        check(false, "getRow of a missing row throws");
    }
    catch (AppwriteException e)
        check(e.code == 404 && e.type == "row_not_found", "a missing row throws AppwriteException 404 row_not_found");

    tablesDB.deleteRow(databaseId: "main", tableId: "todos", rowId: row.id);
    check(events.waitFor(".delete", 10.seconds, event), "realtime delivers the delete event");
    realtime.disconnect();
    check(!realtime.isConnected, "realtime disconnects");

    // Storage: a small file in one request, a large one in chunks
    auto small = storage.createFile(bucketId: "files", fileId: ID.unique(),
        file: InputFile.fromString("hello from D", "hello.txt"), permissions: [Permission.read(Role.user(me.id))]);
    check(small.name == "hello.txt" && small.sizeOriginal == 12, "createFile uploads a small file");
    check(cast(string) storage.getFileDownload(bucketId: "files", fileId: small.id) == "hello from D",
        "getFileDownload returns the file's bytes");

    auto large = new ubyte[12 * 1024 * 1024 + 123];
    foreach (i, ref b; large)
        b = cast(ubyte)(i * 31 + (i >> 9));
    UploadProgress[] progress;
    auto big = storage.createFile(bucketId: "files", fileId: ID.unique(),
        file: InputFile.fromBytes(large, "big.bin"), permissions: [Permission.read(Role.user(me.id))],
        onProgress: (UploadProgress p) { progress ~= p; });
    check(big.sizeOriginal == large.length && big.chunksTotal == 3 && big.chunksUploaded == 3,
        "createFile uploads a large file in 5 MB chunks");
    check(progress.length == 3 && progress[$ - 1].progress == 100.0, "onProgress reports each chunk");
    check(storage.getFileDownload(bucketId: "files", fileId: big.id) == large, "the large file downloads intact");
    auto files = storage.listFiles(bucketId: "files", queries: [Query.orderAsc("name")]);
    check(files.total == 2 && files.files[0].name == "big.bin", "listFiles lists the user's files");

    // Avatars and locale
    auto png = new Avatars(client).getInitials(name: "D Tester", width: 64, height: 64);
    check(png.length > 8 && png[1 .. 4] == cast(const(ubyte)[]) "PNG", "avatars.getInitials returns a PNG");
    auto countries = new Locale(client).listCountries();
    check(countries.total > 100, "locale.listCountries lists countries");

    // async with a dispatcher, as a UI would
    auto ui = new QueueDispatcher;
    string asyncName;
    auto future = async(() => account.get(), ui).then((models.User user) { asyncName = user.name; });
    while (!future.isDone || ui.pending)
        ui.process();
    check(asyncName == "D Tester", "async delivers the result through the dispatcher");

    // Sign out
    auto sessions = account.listSessions();
    check(sessions.total >= 1 && sessions.sessions.canFind!(s => s.current), "listSessions includes the current session");
    account.deleteSession(sessionId: "current");
    try
    {
        account.get();
        check(false, "account.get fails after signing out");
    }
    catch (AppwriteException e)
        check(e.code == 401, "account.get fails with 401 after signing out");

    writeln(failures == 0 ? "All integration checks passed" : failures.to!string ~ " integration checks failed");
    return failures == 0 ? 0 : 1;
}

/// Host of a URL, for looking up cookies.
string hostOf(string url)
{
    import std.string : indexOf;

    auto rest = url[url.indexOf("://") + 3 .. $];
    auto end = rest.indexOf('/');
    rest = end < 0 ? rest : rest[0 .. end];
    auto colon = rest.indexOf(':');
    return colon < 0 ? rest : rest[0 .. colon];
}
