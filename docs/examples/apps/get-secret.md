```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto apps = new Apps(client);

auto result = apps.getSecret(
    appId: "<APP_ID>",
    secretId: "<SECRET_ID>"
);
```
