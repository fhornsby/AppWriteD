/**
 * A small tour of the SDK: sign in, read the account, list rows, upload a file,
 * and make a request through `async` the way a UI would.
 *
 *   APPWRITE_ENDPOINT=https://fra.cloud.appwrite.io/v1 APPWRITE_PROJECT=<id> dub run
 *
 * Optional: APPWRITE_EMAIL / APPWRITE_PASSWORD (otherwise an anonymous session
 * is used), APPWRITE_DATABASE / APPWRITE_TABLE to list rows, APPWRITE_BUCKET to
 * upload this file.
 */
module app;

import std.process : environment;
import std.stdio : writeln, writefln;

import appwrite;

void main()
{
    auto client = new Client()
        .setEndpoint(environment.get("APPWRITE_ENDPOINT", "https://cloud.appwrite.io/v1"))
        .setProject(environment.get("APPWRITE_PROJECT", "<PROJECT_ID>"))
        // Remember the session between runs.
        .setCookieStore(new FileCookieStore(".appwrite-session.json"));

    auto account = new Account(client);

    // Reuse the stored session when there is one, otherwise sign in.
    models.User user;
    try
        user = account.get();
    catch (AppwriteException)
    {
        auto email = environment.get("APPWRITE_EMAIL");
        if (email.length)
            account.createEmailPasswordSession(email: email, password: environment.get("APPWRITE_PASSWORD"));
        else
            account.createAnonymousSession();
        user = account.get();
    }
    writefln("Signed in as %s (%s)", user.name.length ? user.name : "anonymous", user.id);

    // List rows from a table, if one was given.
    auto database = environment.get("APPWRITE_DATABASE");
    auto table = environment.get("APPWRITE_TABLE");
    if (database.length && table.length)
    {
        auto tablesDB = new TablesDB(client);
        auto rows = tablesDB.listRows(databaseId: database, tableId: table, queries: [
            Query.orderDesc("$createdAt"),
            Query.limit(10),
        ]);
        writefln("%s rows in %s, newest first:", rows.total, table);
        foreach (row; rows.rows)
            writeln("  ", row.id, " ", row.toString());
    }

    // Upload this example's source, if a bucket was given.
    auto bucket = environment.get("APPWRITE_BUCKET");
    if (bucket.length)
    {
        auto storage = new Storage(client);
        auto file = storage.createFile(
            bucketId: bucket,
            fileId: ID.unique(),
            file: InputFile.fromPath("source/app.d"),
            permissions: [Permission.read(Role.user(user.id))],
            onProgress: (UploadProgress progress) { writefln("  uploaded %.0f%%", progress.progress); },
        );
        writefln("Uploaded %s (%s bytes)", file.name, file.sizeOriginal);
    }

    // The way a UI calls the API: work on a worker thread, results delivered
    // on the thread that drains the dispatcher (here, this one).
    auto ui = new QueueDispatcher;
    auto locale = new Locale(client);
    auto future = async(() => locale.get(), ui)
        .then((models.Locale info) { writefln("Your country, according to Appwrite: %s", info.country); })
        .onError((Exception e) { writeln("Locale lookup failed: ", e.msg); });
    while (!future.isDone || ui.pending)
        ui.process();
}

