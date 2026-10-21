```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto avatars = new Avatars(client);

auto result = avatars.getCreditCard(
    code: enums.CreditCard.americanExpress,
    width: 0, // optional
    height: 0, // optional
    quality: -1 // optional
);
```
