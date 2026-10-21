```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto oauth2 = new Oauth2(client);

auto result = oauth2.authorize(
    clientId: "<CLIENT_ID>", // optional
    redirectUri: "https://example.com", // optional
    responseType: "", // optional
    scope_: "<SCOPE>", // optional
    state: "<STATE>", // optional
    nonce: "<NONCE>", // optional
    codeChallenge: "<CODE_CHALLENGE>", // optional
    codeChallengeMethod: "s256", // optional
    prompt: "<PROMPT>", // optional
    maxAge: 0, // optional
    authorizationDetails: "<AUTHORIZATION_DETAILS>", // optional
    resource: [], // optional
    audience: "<AUDIENCE>", // optional
    requestUri: "<REQUEST_URI>" // optional
);
```
