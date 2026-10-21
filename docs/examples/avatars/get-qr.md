```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto avatars = new Avatars(client);

auto result = avatars.getQR(
    text: "<TEXT>",
    size: 1, // optional
    margin: 0, // optional
    download: false.nullable // optional
);
```
