/**
 * Print realtime events until Enter is pressed.
 *
 *   APPWRITE_ENDPOINT=https://fra.cloud.appwrite.io/v1 APPWRITE_PROJECT=<id> dub run -- <channel>...
 *
 * Channels default to `account` and every row you can read. Signs in
 * anonymously unless a session is stored (see the basic example), so only
 * events visible to that user arrive.
 */
module app;

import std.process : environment;
import std.stdio : readln, writeln, writefln;

import appwrite;

void main(string[] args)
{
    auto client = new Client()
        .setEndpoint(environment.get("APPWRITE_ENDPOINT", "https://cloud.appwrite.io/v1"))
        .setProject(environment.get("APPWRITE_PROJECT", "<PROJECT_ID>"))
        .setCookieStore(new FileCookieStore(".appwrite-session.json"));

    auto account = new Account(client);
    try
        account.get();
    catch (AppwriteException)
        account.createAnonymousSession();

    string[] channels = args.length > 1 ? args[1 .. $] : [Channel.account(), Channel.rows()];

    auto realtime = new Realtime(client);
    realtime.onError((AppwriteException e) { writeln("realtime error: ", e.msg); });
    realtime.subscribe(channels, (RealtimeMessage message) {
        writefln("%s  %s", message.timestamp, message.events.length ? message.events[0] : "");
        writeln("    ", toJSONString(message.payload));
    });

    writefln("Listening to %s. Press Enter to stop.", channels);
    readln();
    realtime.disconnect();
}

