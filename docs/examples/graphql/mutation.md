```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto graphql = new Graphql(client);

auto result = graphql.mutation(
    query: parseJSON("{\n\t    \"query\": \"mutation { accountUpdateName(name: \\\"Walter\\\") { name } }\"\n\t}")
);
```
