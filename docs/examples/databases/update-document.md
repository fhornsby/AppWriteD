```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto databases = new Databases(client);

auto result = databases.updateDocument(
    databaseId: "<DATABASE_ID>",
    collectionId: "<COLLECTION_ID>",
    documentId: "<DOCUMENT_ID>",
    data: parseJSON("{\n\t    \"username\": \"walter.obrien\",\n\t    \"email\": \"walter.obrien@example.com\",\n\t    \"fullName\": \"Walter O'Brien\",\n\t    \"age\": 33,\n\t    \"isAdmin\": false\n\t}"), // optional
    permissions: [Permission.read(Role.any())], // optional
    transactionId: "<TRANSACTION_ID>" // optional
);
```
