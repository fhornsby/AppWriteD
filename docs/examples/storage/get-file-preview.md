```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto storage = new Storage(client);

auto result = storage.getFilePreview(
    bucketId: "<BUCKET_ID>",
    fileId: "<FILE_ID>",
    width: 0, // optional
    height: 0, // optional
    gravity: enums.ImageGravity.auto_, // optional
    quality: -1, // optional
    borderWidth: 0, // optional
    borderColor: "FFFFFF", // optional
    borderRadius: 0, // optional
    opacity: 0.0, // optional
    rotation: -360, // optional
    background: "FFFFFF", // optional
    output: enums.ImageFormat.jpg, // optional
    token: "<TOKEN>" // optional
);
```
