module appwrite.services.organization;

import std.array : replace;
import std.conv : to;
import std.json;
import std.typecons : Nullable;
import std.uri : encodeComponent;

import appwrite.client;
import appwrite.exception;
import appwrite.input_file;
import appwrite.json;
import appwrite.service;
import appwrite.upload_progress;
import enums = appwrite.enums;
import models = appwrite.models;

/// The Organization service allows you to manage organization-level projects.
class Organization : Service
{
    this(Client client)
    {
        super(client);
    }

    /// List app installations on the organization. Any organization member can read
    /// installations.
    models.AppInstallationList listInstallations(string[] queries = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/organization/installations";

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppInstallationList)(apiResponse.json);
    }

    /// Install an app on the organization. Only organization members with the owner
    /// role can install apps. The installation is granted the scopes the app currently
    /// requests.
    models.AppInstallation createInstallation(string appId, string authorizationDetails = null)
    {
        auto apiPath = "/organization/installations";

        JSONValue[string] apiParams;
        apiParams["appId"] = serialize(appId);
        if (authorizationDetails !is null)
            apiParams["authorizationDetails"] = serialize(authorizationDetails);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppInstallation)(apiResponse.json);
    }

    /// Get an app installation on the organization by its unique ID. Any organization
    /// member can read installations.
    models.AppInstallation getInstallation(string installationId)
    {
        if (installationId.length == 0)
            throw new AppwriteException(`Missing required parameter: "installationId"`);
        auto apiPath = "/organization/installations/{installationId}"
            .replace("{installationId}", encodeComponent(installationId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppInstallation)(apiResponse.json);
    }

    /// Update an app installation on the organization. Only organization members with
    /// the owner role can update installations. The installation's granted scopes are
    /// refreshed to the scopes the app currently requests; previously issued
    /// installation access tokens are revoked.
    models.AppInstallation updateInstallation(string installationId, string authorizationDetails = null)
    {
        if (installationId.length == 0)
            throw new AppwriteException(`Missing required parameter: "installationId"`);
        auto apiPath = "/organization/installations/{installationId}"
            .replace("{installationId}", encodeComponent(installationId));

        JSONValue[string] apiParams;
        if (authorizationDetails !is null)
            apiParams["authorizationDetails"] = serialize(authorizationDetails);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppInstallation)(apiResponse.json);
    }

    /// Uninstall an app from the organization by its installation ID. Only organization
    /// members with the owner role can remove installations. Previously issued
    /// installation access tokens are revoked.
    void deleteInstallation(string installationId)
    {
        if (installationId.length == 0)
            throw new AppwriteException(`Missing required parameter: "installationId"`);
        auto apiPath = "/organization/installations/{installationId}"
            .replace("{installationId}", encodeComponent(installationId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }
}
