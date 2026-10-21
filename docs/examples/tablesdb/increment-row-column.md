```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto tablesDB = new TablesDB(client);

auto result = tablesDB.incrementRowColumn(
    databaseId: "<DATABASE_ID>",
    tableId: "<TABLE_ID>",
    rowId: "<ROW_ID>",
    column: "<COLUMN>",
    value: 1.0, // optional
    max: 100.0, // optional
    transactionId: "<TRANSACTION_ID>" // optional
);
```
