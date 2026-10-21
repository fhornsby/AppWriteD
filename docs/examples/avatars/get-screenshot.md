```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto avatars = new Avatars(client);

auto result = avatars.getScreenshot(
    url: "https://example.com",
    headers: parseJSON("{\n\t    \"Accept-Language\": \"en-US,en;q=0.9\"\n\t}"), // optional
    viewportWidth: 1920, // optional
    viewportHeight: 1080, // optional
    scale: 2.0, // optional
    theme: enums.BrowserTheme.dark, // optional
    userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15", // optional
    fullpage: true.nullable, // optional
    locale: "en-US", // optional
    timezone: enums.Timezone.africaAbidjan, // optional
    latitude: 37.7749, // optional
    longitude: -122.4194, // optional
    accuracy: 100.0, // optional
    touch: true.nullable, // optional
    permissions: [enums.BrowserPermission.geolocation, enums.BrowserPermission.notifications], // optional
    sleep: 3, // optional
    width: 800, // optional
    height: 600, // optional
    quality: 85, // optional
    output: enums.ImageFormat.jpeg // optional
);
```
