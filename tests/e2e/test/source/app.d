/**
 * End-to-end test of the generated SDK against the sdk-generator mock server.
 *
 * Mirrors the Flutter e2e script in appwrite/sdk-generator: every line printed
 * after "Test Started" is compared with the expected output by run.php.
 */
module app;

import core.sync.mutex : Mutex;
import core.thread : Thread;
import core.time : MonoTime, msecs, seconds, Duration;
import std.algorithm : map;
import std.array : join;
import std.conv : to;
import std.process : environment;
import std.stdio : stdout, writeln;

import appwrite;

/// Collects realtime events, so the main thread can wait for them.
final class Inbox
{
    private Mutex lock;
    private RealtimeMessage[] messages;
    private AppwriteException[] errors;

    this()
    {
        lock = new Mutex;
    }

    void add(RealtimeMessage message)
    {
        synchronized (lock)
            messages ~= message;
    }

    void fail(AppwriteException error)
    {
        synchronized (lock)
            errors ~= error;
    }

    bool waitMessage(Duration timeout, out RealtimeMessage message)
    {
        auto deadline = MonoTime.currTime + timeout;
        while (MonoTime.currTime < deadline)
        {
            synchronized (lock)
                if (messages.length)
                {
                    message = messages[0];
                    return true;
                }
            Thread.sleep(20.msecs);
        }
        return false;
    }

    bool waitError(Duration timeout)
    {
        auto deadline = MonoTime.currTime + timeout;
        while (MonoTime.currTime < deadline)
        {
            synchronized (lock)
                if (errors.length)
                    return true;
            Thread.sleep(20.msecs);
        }
        return false;
    }
}

void main()
{
    auto endpoint = environment.get("MOCK_ENDPOINT", "http://localhost:8080/v1");
    auto realtimeEndpoint = environment.get("MOCK_REALTIME_ENDPOINT", "ws://localhost:8080/v1");
    auto resources = environment.get("MOCK_RESOURCES", "../../../generator/vendor/appwrite/sdk-generator/tests/resources");

    auto client = new Client()
        .setProject("123456")
        .addHeader("Origin", "http://localhost");

    auto foo = new Foo(client);
    auto bar = new Bar(client);
    auto general = new General(client);

    client.setSelfSigned();
    client.setProject("console");
    client.setEndpoint(endpoint);
    client.setEndpointRealtime(realtimeEndpoint);

    auto realtime = new Realtime(client);
    auto plain = new Inbox, withQueries = new Inbox, withFailingQueries = new Inbox, presence = new Inbox;
    realtime.subscribe(["tests"], &plain.add);
    auto rtsubWithQueries = realtime.subscribe(["tests"], &withQueries.add,
        [Query.equal("response", ["WS:/v1/realtime:passed"])]);
    auto rtsubWithQueriesFailure = realtime.subscribe(["tests"], &withFailingQueries.add,
        [Query.equal("response", ["failed"])]);
    realtime.subscribe(["presences"], (RealtimeMessage message) {
        if (message.payload.type == JSONType.object && "$id" in message.payload
            && message.payload["$id"].str == "p-test")
            presence.add(message);
    });

    Thread.sleep(2.seconds);
    writeln("\nTest Started");

    // Ping
    client.setProject("123456");
    writeln(parseJSON(client.ping())["result"].str);
    client.setProject("console");

    // Foo
    writeln(foo.get(x: "string", y: 123, z: ["string in array"]).result);
    writeln(foo.post(x: "string", y: 123, z: ["string in array"]).result);
    writeln(foo.put(x: "string", y: 123, z: ["string in array"]).result);
    writeln(foo.patch(x: "string", y: 123, z: ["string in array"]).result);
    writeln(foo.delete_(x: "string", y: 123, z: ["string in array"]).result);

    // Bar
    writeln(bar.get(required: "string", default_: 123, z: ["string in array"]).result);
    writeln(bar.post(required: "string", default_: 123, z: ["string in array"]).result);
    writeln(bar.put(required: "string", default_: 123, z: ["string in array"]).result);
    writeln(bar.patch(required: "string", default_: 123, z: ["string in array"]).result);
    writeln(bar.delete_(required: "string", default_: 123, z: ["string in array"]).result);

    // General
    general.redirect();
    writeln(general.redirected().result);

    foreach (ids; [["", "0"], ["0", ""]])
    {
        try
        {
            general.validatePath(id: ids[0], plain: ids[1]);
            writeln("Empty path parameter was accepted");
        }
        catch (AppwriteException e)
            writeln(e.msg);
    }
    writeln(general.validatePath(id: "0", plain: "0").result);
    writeln(general.validatePath(id: null, plain: "0").result);

    auto plaintext = new Plaintext(client);
    writeln(plaintext.getZone());
    writeln(general.getMixed().result);
    writeln(plaintext.importZone(records: "www 3600 IN A 192.0.2.1"));
    writeln(plaintext.importZone(records: "www 3600 IN A 192.0.2.1",
            zone: InputFile.fromPath(resources ~ "/file.png", "file.png")));

    enum message = "conversation without a required file";
    auto metadata = parseJSON(`{"source":"sdk","uri":"café"}`);
    writeln(general.optionalUpload(message: message).result);
    writeln(general.optionalUpload(message: message,
            attachment: InputFile.fromPath(resources ~ "/file.png", "file.png")).result);
    writeln(general.optionalUpload(message: message, metadata: metadata).result);
    writeln(general.optionalUpload(message: message,
            attachment: InputFile.fromPath(resources ~ "/file.png", "file.png"), metadata: metadata).result);

    writeln(general.upload(x: "string", y: 123, z: ["string in array"],
            file: InputFile.fromPath(resources ~ "/file.png", "file.png")).result);
    UploadProgress last;
    writeln(general.upload(x: "string", y: 123, z: ["string in array"],
            file: InputFile.fromPath(resources ~ "/large_file.mp4", "large_file.mp4"),
            onProgress: (UploadProgress progress) { last = progress; }).result);
    import std.file : read;

    writeln(general.upload(x: "string", y: 123, z: ["string in array"],
            file: InputFile.fromBytes(cast(ubyte[]) read(resources ~ "/file.png"), "file.png")).result);
    writeln(general.upload(x: "string", y: 123, z: ["string in array"],
            file: InputFile.fromBytes(cast(ubyte[]) read(resources ~ "/large_file.mp4"), "large_file.mp4")).result);
    if (last.progress != 100.0 || last.chunksUploaded != last.chunksTotal)
        writeln("Upload progress did not reach 100%: ", last);

    auto profile = general.uploadGeneric(file: InputFile.fromPath(resources ~ "/file.png", "file.png"));
    writeln(profile.prefs["result"].str);

    writeln(cast(string) general.download());

    writeln(general.enum_(mockType: enums.MockType.first).result);

    // An omitted optional number is not sent; zero is.
    writeln(general.getOptional(height: 128, name: "omitted").result);
    writeln(general.getOptional(width: 0, height: 64, name: "zero").result);

    writeln(general.createPlayer(player: models.Player(id: "player1", name: "John Doe", score: 100)).result);
    writeln(general.createPlayers(players: [
        models.Player(id: "player1", name: "John Doe", score: 100),
        models.Player(id: "player2", name: "Jane Doe", score: 200),
    ]).result);

    auto preset = general.getPreset();
    writeln("preset: name=", preset.name, ", count=", preset.count, ", enabled=", preset.enabled);
    foreach (item; general.listPresets().presets)
        writeln("preset: name=", item.name, ", count=", item.count, ", enabled=", item.enabled);
    writeln("empty presets: ", general.listEmptyPresets().presets.length);
    writeln("preset verified: ", preset.verified.isNull ? "null" : preset.verified.get.to!string);
    writeln("preset scopes: ", preset.scopes.map!(scope_ => cast(string) scope_).join(","));
    auto options = general.getPresetSettings().options;
    writeln("preset settings: options=", options.type == JSONType.object ? options.object.length : 0);
    auto prefs = general.getPresetProfile().prefs.data;
    writeln("preset profile: prefs=", prefs.type == JSONType.object ? prefs.object.length : 0);

    foreach (call; [&general.error400, &general.error500])
    {
        try
            call();
        catch (AppwriteException e)
        {
            writeln(e.msg);
            writeln(e.response);
        }
    }
    try
        general.error502();
    catch (AppwriteException e)
    {
        writeln(e.msg);
        writeln(e.response);
    }

    try
        client.setEndpoint("htp://cloud.appwrite.io/v1");
    catch (AppwriteException e)
        writeln(e.msg);

    // Realtime, in a fixed order.
    RealtimeMessage event;
    writeln(plain.waitMessage(10.seconds, event) ? event.payload["response"].str : "Realtime message timed out");
    writeln(withQueries.waitMessage(10.seconds, event) ? event.payload["response"].str : "Realtime message timed out");
    // A message here means query filtering failed; either way realtime "failed" for this subscription.
    withFailingQueries.waitMessage(2.seconds, event);
    writeln("Realtime failed!");

    auto errorRealtime = new Realtime(client);
    auto errors = new Inbox;
    errorRealtime.onError(&errors.fail);
    errorRealtime.subscribe(["error"], (RealtimeMessage message) {});
    writeln(errors.waitError(10.seconds) ? "Realtime error:passed" : "Realtime error:failed");
    errorRealtime.disconnect();

    try
    {
        rtsubWithQueriesFailure.unsubscribe();
        rtsubWithQueriesFailure.unsubscribe();
        writeln("Realtime unsubscribe:passed");
    }
    catch (Exception)
        writeln("Realtime unsubscribe:failed");

    try
    {
        rtsubWithQueries.update(["tests"], []);
        writeln("Realtime update:passed");
    }
    catch (Exception)
        writeln("Realtime update:failed");

    realtime.upsertPresence("online", "p-test", null, parseJSON(`{"page":"/home"}`));
    writeln(presence.waitMessage(5.seconds, event) ? "Realtime presence:passed" : "Realtime presence:failed");

    try
    {
        realtime.disconnect();
        writeln("Realtime disconnect:passed");
    }
    catch (Exception)
        writeln("Realtime disconnect:failed");

    writeln(general.setCookie().result);
    writeln(general.getCookie().result);

    general.empty();

    // Query helpers
    writeln(Query.equal("released", [true]));
    writeln(Query.equal("title", ["Spiderman", "Dr. Strange"]));
    writeln(Query.notEqual("title", "Spiderman"));
    writeln(Query.lessThan("releasedYear", 1990));
    writeln(Query.greaterThan("releasedYear", 1990));
    writeln(Query.search("name", "john"));
    writeln(Query.isNull("name"));
    writeln(Query.isNotNull("name"));
    writeln(Query.between("age", 50, 100));
    writeln(Query.between("age", 50.5, 100.5));
    writeln(Query.between("name", "Anna", "Brad"));
    writeln(Query.startsWith("name", "Ann"));
    writeln(Query.endsWith("name", "nne"));
    writeln(Query.select(["name", "age"]));
    writeln(Query.orderAsc("title"));
    writeln(Query.orderDesc("title"));
    writeln(Query.orderRandom());
    writeln(Query.cursorAfter("my_movie_id"));
    writeln(Query.cursorBefore("my_movie_id"));
    writeln(Query.limit(50));
    writeln(Query.offset(20));
    writeln(Query.contains("title", "Spider"));
    writeln(Query.contains("labels", "first"));
    writeln(Query.containsAny("labels", ["first", "second"]));
    writeln(Query.containsAll("labels", ["first", "second"]));
    writeln(Query.notContains("title", "Spider"));
    writeln(Query.notSearch("name", "john"));
    writeln(Query.notBetween("age", 50, 100));
    writeln(Query.notStartsWith("name", "Ann"));
    writeln(Query.notEndsWith("name", "nne"));
    writeln(Query.createdBefore("2023-01-01"));
    writeln(Query.createdAfter("2023-01-01"));
    writeln(Query.createdBetween("2023-01-01", "2023-12-31"));
    writeln(Query.updatedBefore("2023-01-01"));
    writeln(Query.updatedAfter("2023-01-01"));
    writeln(Query.updatedBetween("2023-01-01", "2023-12-31"));
    writeln(Query.distanceEqual("location", [[40.7128, -74], [40.7128, -74]], 1000));
    writeln(Query.distanceEqual("location", [40.7128, -74], 1000, true));
    writeln(Query.distanceNotEqual("location", [40.7128, -74], 1000));
    writeln(Query.distanceNotEqual("location", [40.7128, -74], 1000, true));
    writeln(Query.distanceGreaterThan("location", [40.7128, -74], 1000));
    writeln(Query.distanceGreaterThan("location", [40.7128, -74], 1000, true));
    writeln(Query.distanceLessThan("location", [40.7128, -74], 1000));
    writeln(Query.distanceLessThan("location", [40.7128, -74], 1000, true));
    writeln(Query.vectorDot("embedding", [0.1, 0.2, 0.3]));
    writeln(Query.vectorCosine("embedding", [0.1, 0.2, 0.3]));
    writeln(Query.vectorEuclidean("embedding", [0.1, 0.2, 0.3]));
    writeln(Query.intersects("location", [40.7128, -74]));
    writeln(Query.notIntersects("location", [40.7128, -74]));
    writeln(Query.crosses("location", [40.7128, -74]));
    writeln(Query.notCrosses("location", [40.7128, -74]));
    writeln(Query.overlaps("location", [40.7128, -74]));
    writeln(Query.notOverlaps("location", [40.7128, -74]));
    writeln(Query.touches("location", [40.7128, -74]));
    writeln(Query.notTouches("location", [40.7128, -74]));
    writeln(Query.contains("location", [[40.7128, -74], [40.7128, -74]]));
    writeln(Query.notContains("location", [[40.7128, -74], [40.7128, -74]]));
    writeln(Query.equal("location", [[40.7128, -74], [40.7128, -74]]));
    writeln(Query.notEqual("location", [[40.7128, -74], [40.7128, -74]]));
    writeln(Query.or([Query.equal("released", true), Query.lessThan("releasedYear", 1990)]));
    writeln(Query.and([Query.equal("released", false), Query.greaterThan("releasedYear", 2015)]));
    writeln(Query.regex("name", "pattern.*"));
    writeln(Query.exists(["attr1", "attr2"]));
    writeln(Query.notExists(["attr1", "attr2"]));
    writeln(Query.elemMatch("friends", [Query.equal("name", "Alice"), Query.greaterThan("age", 18)]));
    writeln(Query.relationship("comments", [Query.equal("approved", true), Query.limit(2)]));

    auto queryTransport = general.listRows(queries: [
        Query.count("*", "total"),
        Query.join("orders", "$id", "customerId"),
        Query.groupBy(["status"]),
        Query.distinct(),
        Query.covers("location", [1, 2]),
        Query.countDistinct("year", "uniqueYears"),
        Query.sum("price", "total"),
        Query.avg("price", "avgPrice"),
        Query.min("price", "lowest"),
        Query.max("price", "highest"),
        Query.stddev("price", "sd"),
        Query.stddevPop("price", "sdp"),
        Query.stddevSamp("price", "sds"),
        Query.variance("price", "var"),
        Query.varPop("price", "vp"),
        Query.varSamp("price", "vs"),
        Query.bitAnd("flags", "band"),
        Query.bitOr("flags", "bor"),
        Query.bitXor("flags", "bxor"),
        Query.having([Query.greaterThan("total", 1)]),
        Query.leftJoin("orders", "$id", "customerId", "=", "ord"),
        Query.rightJoin("orders", "$id", "customerId"),
        Query.fullOuterJoin("orders", "$id", "customerId"),
        Query.crossJoin("orders", "ord"),
        Query.on("$id", "customerId"),
        Query.leftJoin("orders", "ord", [Query.on("$id", "customerId"), Query.equal("ord.status", "paid")]),
        Query.notCovers("location", [1, 2]),
        Query.spatialEquals("location", [1, 2]),
        Query.notSpatialEquals("location", [1, 2]),
    ] ~ Query.page(2, 10) ~ [Query.limit(1)]);
    writeln(queryTransport.result);

    // Permission & Role helpers
    writeln(Permission.read(Role.any()));
    writeln(Permission.write(Role.user(ID.custom("userid"))));
    writeln(Permission.create(Role.users()));
    writeln(Permission.update(Role.guests()));
    writeln(Permission.delete_(Role.team("teamId", "owner")));
    writeln(Permission.delete_(Role.team("teamId")));
    writeln(Permission.create(Role.member("memberId")));
    writeln(Permission.update(Role.users("verified")));
    writeln(Permission.update(Role.user(ID.custom("userid"), "unverified")));
    writeln(Permission.create(Role.label("admin")));

    // ID helpers
    writeln(ID.unique());
    writeln(ID.custom("custom_id"));

    // Channel helpers
    writeln(Channel.database("db1").collection("col1").document().toString());
    writeln(Channel.database("db1").collection("col1").document("doc1").toString());
    writeln(Channel.database("db1").collection("col1").document("doc1").create().toString());
    writeln(Channel.database("db1").collection("col1").document("doc1").upsert().toString());
    writeln(Channel.tablesdb("db1").table("table1").row().toString());
    writeln(Channel.tablesdb("db1").table("table1").row("row1").toString());
    writeln(Channel.tablesdb("db1").table("table1").row("row1").update().toString());
    writeln(Channel.account());
    writeln(Channel.bucket("bucket1").file().toString());
    writeln(Channel.bucket("bucket1").file("file1").toString());
    writeln(Channel.bucket("bucket1").file("file1").delete_().toString());
    writeln(Channel.function_("func2").toString());
    writeln(Channel.function_("func1").toString());
    writeln(Channel.execution("exec2").toString());
    writeln(Channel.execution("exec1").toString());
    writeln(Channel.documents());
    writeln(Channel.rows());
    writeln(Channel.files());
    writeln(Channel.executions());
    writeln(Channel.teams());
    writeln(Channel.team("team2").toString());
    writeln(Channel.team("team1").toString());
    writeln(Channel.team("team1").create().toString());
    writeln(Channel.memberships());
    writeln(Channel.membership("membership2").toString());
    writeln(Channel.membership("membership1").toString());
    writeln(Channel.membership("membership1").update().toString());
    writeln(Channel.presences());
    writeln(Channel.presence("presence2").toString());
    writeln(Channel.presence("presence1").toString());
    writeln(Channel.presence("presence1").upsert().toString());
    writeln(Channel.presence("presence1").update().toString());
    writeln(Channel.presence("presence1").delete_().toString());

    // Operator helpers
    writeln(Operator.increment(1));
    writeln(Operator.increment(5, 100));
    writeln(Operator.decrement(1));
    writeln(Operator.decrement(3, 0));
    writeln(Operator.multiply(2));
    writeln(Operator.multiply(3, 1000));
    writeln(Operator.divide(2));
    writeln(Operator.divide(4, 1));
    writeln(Operator.modulo(5));
    writeln(Operator.power(2));
    writeln(Operator.power(3, 100));
    writeln(Operator.arrayAppend(["item1", "item2"]));
    writeln(Operator.arrayPrepend(["first", "second"]));
    writeln(Operator.arrayInsert(0, "newItem"));
    writeln(Operator.arrayRemove("oldItem"));
    writeln(Operator.arrayUnique());
    writeln(Operator.arrayIntersect(["a", "b", "c"]));
    writeln(Operator.arrayDiff(["x", "y"]));
    writeln(Operator.arrayFilter(Condition.equal, "test"));
    writeln(Operator.stringConcat("suffix"));
    writeln(Operator.stringReplace("old", "new"));
    writeln(Operator.toggle());
    writeln(Operator.dateAddDays(7));
    writeln(Operator.dateSubDays(3));
    writeln(Operator.dateSetNow());

    writeln(general.headers().result);
    stdout.flush();
}
