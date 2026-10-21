```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto presences = new Presences(client);

auto result = presences.get(
    presenceId: "<PRESENCE_ID>"
);
```
