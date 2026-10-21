```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto apps = new Apps(client);

auto result = apps.list(
    queries: [], // optional
    total: false.nullable // optional
);
```
