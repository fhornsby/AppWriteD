```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto account = new Account(client);

auto result = account.createEmailToken(
    userId: "<USER_ID>",
    email: "email@example.com",
    phrase: false.nullable // optional
);
```
