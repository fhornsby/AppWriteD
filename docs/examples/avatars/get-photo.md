```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto avatars = new Avatars(client);

auto result = avatars.getPhoto(
    width: 0, // optional
    height: 0, // optional
    quality: 0, // optional
    output: "png", // optional
    rating: "g", // optional
    userId: "current()", // optional
    emailHash: "<EMAIL_HASH>", // optional
    name: "<NAME>" // optional
);
```
