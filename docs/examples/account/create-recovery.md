```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto account = new Account(client);

auto result = account.createRecovery(
    email: "email@example.com",
    url: "https://example.com"
);
```
