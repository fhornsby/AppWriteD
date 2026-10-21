```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto databases = new Databases(client);

auto result = databases.updateTransaction(
    transactionId: "<TRANSACTION_ID>",
    commit: false.nullable, // optional
    rollback: false.nullable // optional
);
```
