```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto account = new Account(client);

auto result = account.createIdTokenSession(
    provider: enums.IdTokenProvider.apple,
    idToken: "<ID_TOKEN>",
    nonce: "<NONCE>", // optional
    accessToken: "<ACCESS_TOKEN>", // optional
    accessTokenExpiry: 0, // optional
    name: "<NAME>" // optional
);
```
