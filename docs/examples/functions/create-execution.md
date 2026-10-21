```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto functions = new Functions(client);

auto result = functions.createExecution(
    functionId: "<FUNCTION_ID>",
    body_: "<BODY>", // optional
    async: false.nullable, // optional
    path: "<PATH>", // optional
    method: enums.ExecutionMethod.gET, // optional
    headers: parseJSON("{}"), // optional
    scheduledAt: "<SCHEDULED_AT>" // optional
);
```
