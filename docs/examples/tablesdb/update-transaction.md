```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto tablesDB = new TablesDB(client);

auto result = tablesDB.updateTransaction(
    transactionId: "<TRANSACTION_ID>",
    commit: false.nullable, // optional
    rollback: false.nullable // optional
);
```
