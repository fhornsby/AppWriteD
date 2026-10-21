```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto storage = new Storage(client);

auto result = storage.createFile(
    bucketId: "<BUCKET_ID>",
    fileId: "<FILE_ID>",
    file: InputFile.fromPath("file.png"),
    permissions: [Permission.read(Role.any())], // optional
    folder: "photos/2026" // optional
);
```
