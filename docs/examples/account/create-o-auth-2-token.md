```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto account = new Account(client);

auto result = account.createOAuth2Token(
    provider: enums.OAuthProvider.amazon,
    success: "https://example.com", // optional
    failure: "https://example.com", // optional
    scopes: [], // optional
    state: "<STATE>" // optional
);
```
