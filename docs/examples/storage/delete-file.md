```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto storage = new Storage(client);

storage.deleteFile(
    bucketId: "<BUCKET_ID>",
    fileId: "<FILE_ID>"
);
```
