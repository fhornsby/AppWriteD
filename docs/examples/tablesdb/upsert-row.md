```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto tablesDB = new TablesDB(client);

auto result = tablesDB.upsertRow(
    databaseId: "<DATABASE_ID>",
    tableId: "<TABLE_ID>",
    rowId: "<ROW_ID>",
    data: parseJSON("{\n\t    \"username\": \"walter.obrien\",\n\t    \"email\": \"walter.obrien@example.com\",\n\t    \"fullName\": \"Walter O'Brien\",\n\t    \"age\": 33,\n\t    \"isAdmin\": false\n\t}"), // optional
    permissions: [Permission.read(Role.any())], // optional
    transactionId: "<TRANSACTION_ID>" // optional
);
```
