```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto oauth2 = new Oauth2(client);

auto result = oauth2.createPAR(
    clientId: "<CLIENT_ID>",
    redirectUri: "https://example.com",
    responseType: "code",
    scope_: "<SCOPE>", // optional
    state: "<STATE>", // optional
    nonce: "<NONCE>", // optional
    codeChallenge: "<CODE_CHALLENGE>", // optional
    codeChallengeMethod: "s256", // optional
    prompt: "<PROMPT>", // optional
    maxAge: 0, // optional
    authorizationDetails: "<AUTHORIZATION_DETAILS>", // optional
    resource: [], // optional
    audience: "<AUDIENCE>" // optional
);
```
