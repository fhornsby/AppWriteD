```d
import appwrite;

auto client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1") // Your API Endpoint
    .setProject("<YOUR_PROJECT_ID>"); // Your project ID

auto teams = new Teams(client);

teams.deleteInstallation(
    teamId: "<TEAM_ID>",
    installationId: "<INSTALLATION_ID>"
);
```
