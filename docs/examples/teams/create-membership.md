```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto teams = new Teams(client);

auto result = teams.createMembership(
    teamId: "<TEAM_ID>",
    roles: ["editor"],
    email: "email@example.com", // optional
    userId: "<USER_ID>", // optional
    phone: "+12065550100", // optional
    url: "https://example.com", // optional
    name: "<NAME>", // optional
    membershipId: "<MEMBERSHIP_ID>" // optional
);
```
