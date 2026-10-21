```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto functions = new Functions(client);

auto result = functions.listExecutions(
    functionId: "<FUNCTION_ID>",
    queries: [], // optional
    total: false.nullable // optional
);
```
