```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto databases = new Databases(client);

auto result = databases.decrementDocumentAttribute(
    databaseId: "<DATABASE_ID>",
    collectionId: "<COLLECTION_ID>",
    documentId: "<DOCUMENT_ID>",
    attribute: "<ATTRIBUTE>",
    value: 1.0, // optional
    min: 0.0, // optional
    transactionId: "<TRANSACTION_ID>" // optional
);
```
