```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto tablesDB = new TablesDB(client);

auto result = tablesDB.createOperations(
    transactionId: "<TRANSACTION_ID>",
    operations: [parseJSON("{\"action\":\"create\",\"databaseId\":\"<DATABASE_ID>\",\"tableId\":\"<TABLE_ID>\",\"rowId\":\"<ROW_ID>\",\"data\":{\"name\":\"Walter O'Brien\"}}")] // optional
);
```
