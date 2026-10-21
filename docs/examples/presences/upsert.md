```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto presences = new Presences(client);

auto result = presences.upsert(
    presenceId: "<PRESENCE_ID>",
    status: "<STATUS>",
    permissions: [Permission.read(Role.any())], // optional
    expiresAt: "2020-10-15T06:38:00.000+00:00", // optional
    metadata: parseJSON("{}") // optional
);
```
