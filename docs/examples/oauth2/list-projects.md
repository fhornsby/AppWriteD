```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto oauth2 = new Oauth2(client);

auto result = oauth2.listProjects(
    limit: 1, // optional
    offset: 0, // optional
    search: "<SEARCH>" // optional
);
```
