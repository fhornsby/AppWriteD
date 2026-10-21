```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto databases = new Databases(client);

auto result = databases.listDocuments(
    databaseId: "<DATABASE_ID>",
    collectionId: "<COLLECTION_ID>",
    queries: [], // optional
    transactionId: "<TRANSACTION_ID>", // optional
    total: false.nullable, // optional
    ttl: 0 // optional
);
```
