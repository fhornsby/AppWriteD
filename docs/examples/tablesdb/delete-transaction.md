```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto tablesDB = new TablesDB(client);

tablesDB.deleteTransaction(
    transactionId: "<TRANSACTION_ID>"
);
```
