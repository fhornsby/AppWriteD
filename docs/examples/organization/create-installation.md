```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto organization = new Organization(client);

auto result = organization.createInstallation(
    appId: "<APP_ID>",
    authorizationDetails: "<AUTHORIZATION_DETAILS>" // optional
);
```
