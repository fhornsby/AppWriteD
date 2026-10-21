```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto databases = new Databases(client);

auto result = databases.createOperations(
    transactionId: "<TRANSACTION_ID>",
    operations: [parseJSON("{\"action\":\"create\",\"databaseId\":\"<DATABASE_ID>\",\"collectionId\":\"<COLLECTION_ID>\",\"documentId\":\"<DOCUMENT_ID>\",\"data\":{\"name\":\"Walter O'Brien\"}}")] // optional
);
```
