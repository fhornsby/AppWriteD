```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto oauth2 = new Oauth2(client);

auto result = oauth2.createToken(
    grantType: "<GRANT_TYPE>",
    code: "<CODE>", // optional
    refreshToken: "<REFRESH_TOKEN>", // optional
    deviceCode: "<DEVICE_CODE>", // optional
    clientId: "<CLIENT_ID>", // optional
    clientSecret: "<CLIENT_SECRET>", // optional
    codeVerifier: "<CODE_VERIFIER>", // optional
    redirectUri: "https://example.com", // optional
    resource: [], // optional
    audience: "<AUDIENCE>" // optional
);
```
