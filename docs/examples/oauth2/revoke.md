```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto oauth2 = new Oauth2(client);

auto result = oauth2.revoke(
    token: "<TOKEN>",
    tokenTypeHint: "access_token", // optional
    clientId: "<CLIENT_ID>", // optional
    clientSecret: "<CLIENT_SECRET>" // optional
);
```
