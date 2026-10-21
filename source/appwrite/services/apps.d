module appwrite.services.apps;

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

/// The Apps service allows you to manage OAuth2 applications, their keys, secrets,
/// scopes, and installations.
class Apps : Service
{
    this(Client client)
    {
        super(client);
    }

    /// List applications.
    models.AppsList list(string[] queries = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/apps";

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppsList)(apiResponse.json);
    }

    /// Create a new application.
    models.App create(string appId, string name, string[] redirectUris, string description = null, string clientUri = null, string logoUri = null, string privacyPolicyUrl = null, string termsUrl = null, string[] contacts = null, string tagline = null, string[] tags = null, string[] images = null, string supportUrl = null, string dataDeletionUrl = null, string[] postLogoutRedirectUris = null, Nullable!(bool) enabled = Nullable!(bool).init, string type = null, Nullable!(bool) deviceFlow = Nullable!(bool).init, string teamId = null)
    {
        auto apiPath = "/apps";

        JSONValue[string] apiParams;
        apiParams["appId"] = serialize(appId);
        apiParams["name"] = serialize(name);
        if (description !is null)
            apiParams["description"] = serialize(description);
        if (clientUri !is null)
            apiParams["clientUri"] = serialize(clientUri);
        if (logoUri !is null)
            apiParams["logoUri"] = serialize(logoUri);
        if (privacyPolicyUrl !is null)
            apiParams["privacyPolicyUrl"] = serialize(privacyPolicyUrl);
        if (termsUrl !is null)
            apiParams["termsUrl"] = serialize(termsUrl);
        if (contacts !is null)
            apiParams["contacts"] = serialize(contacts);
        if (tagline !is null)
            apiParams["tagline"] = serialize(tagline);
        if (tags !is null)
            apiParams["tags"] = serialize(tags);
        if (images !is null)
            apiParams["images"] = serialize(images);
        if (supportUrl !is null)
            apiParams["supportUrl"] = serialize(supportUrl);
        if (dataDeletionUrl !is null)
            apiParams["dataDeletionUrl"] = serialize(dataDeletionUrl);
        apiParams["redirectUris"] = serialize(redirectUris);
        if (postLogoutRedirectUris !is null)
            apiParams["postLogoutRedirectUris"] = serialize(postLogoutRedirectUris);
        if (!enabled.isNull)
            apiParams["enabled"] = serialize(enabled);
        if (type !is null)
            apiParams["type"] = serialize(type);
        if (!deviceFlow.isNull)
            apiParams["deviceFlow"] = serialize(deviceFlow);
        if (teamId !is null)
            apiParams["teamId"] = serialize(teamId);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.App)(apiResponse.json);
    }

    /// List scopes an application can request when installed on a team.
    models.AppScopeList listInstallationScopes()
    {
        auto apiPath = "/apps/scopes/installations";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppScopeList)(apiResponse.json);
    }

    /// List scopes an application can request during the OAuth2 flow.
    models.AppScopeList listOAuth2Scopes()
    {
        auto apiPath = "/apps/scopes/oauth2";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppScopeList)(apiResponse.json);
    }

    /// Get an application by its unique ID.
    models.App get(string appId)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        auto apiPath = "/apps/{appId}"
            .replace("{appId}", encodeComponent(appId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.App)(apiResponse.json);
    }

    /// Update an application by its unique ID.
    models.App update(string appId, string name, string description = null, string clientUri = null, string logoUri = null, string privacyPolicyUrl = null, string termsUrl = null, string[] contacts = null, string tagline = null, string[] tags = null, string[] images = null, string supportUrl = null, string dataDeletionUrl = null, Nullable!(bool) enabled = Nullable!(bool).init, string[] redirectUris = null, string[] postLogoutRedirectUris = null, string type = null, Nullable!(bool) deviceFlow = Nullable!(bool).init, string[] installationScopes = null, string installationRedirectUrl = null)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        auto apiPath = "/apps/{appId}"
            .replace("{appId}", encodeComponent(appId));

        JSONValue[string] apiParams;
        apiParams["name"] = serialize(name);
        if (description !is null)
            apiParams["description"] = serialize(description);
        if (clientUri !is null)
            apiParams["clientUri"] = serialize(clientUri);
        if (logoUri !is null)
            apiParams["logoUri"] = serialize(logoUri);
        if (privacyPolicyUrl !is null)
            apiParams["privacyPolicyUrl"] = serialize(privacyPolicyUrl);
        if (termsUrl !is null)
            apiParams["termsUrl"] = serialize(termsUrl);
        if (contacts !is null)
            apiParams["contacts"] = serialize(contacts);
        if (tagline !is null)
            apiParams["tagline"] = serialize(tagline);
        if (tags !is null)
            apiParams["tags"] = serialize(tags);
        if (images !is null)
            apiParams["images"] = serialize(images);
        if (supportUrl !is null)
            apiParams["supportUrl"] = serialize(supportUrl);
        if (dataDeletionUrl !is null)
            apiParams["dataDeletionUrl"] = serialize(dataDeletionUrl);
        if (!enabled.isNull)
            apiParams["enabled"] = serialize(enabled);
        if (redirectUris !is null)
            apiParams["redirectUris"] = serialize(redirectUris);
        if (postLogoutRedirectUris !is null)
            apiParams["postLogoutRedirectUris"] = serialize(postLogoutRedirectUris);
        if (type !is null)
            apiParams["type"] = serialize(type);
        if (!deviceFlow.isNull)
            apiParams["deviceFlow"] = serialize(deviceFlow);
        if (installationScopes !is null)
            apiParams["installationScopes"] = serialize(installationScopes);
        if (installationRedirectUrl !is null)
            apiParams["installationRedirectUrl"] = serialize(installationRedirectUrl);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.App)(apiResponse.json);
    }

    /// Delete an application by its unique ID.
    void delete_(string appId)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        auto apiPath = "/apps/{appId}"
            .replace("{appId}", encodeComponent(appId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// List installations of an application. Requires an app key sent in the
    /// `X-Appwrite-Key` header alongside the `X-Appwrite-App` header, or a caller with
    /// update access to the app.
    models.AppInstallationList listInstallations(string appId, string[] queries = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        auto apiPath = "/apps/{appId}/installations"
            .replace("{appId}", encodeComponent(appId));

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

    /// Get an installation of an application by its unique ID. Requires an app key sent
    /// in the `X-Appwrite-Key` header alongside the `X-Appwrite-App` header, or a
    /// caller with update access to the app.
    models.AppInstallation getInstallation(string appId, string installationId)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        if (installationId.length == 0)
            throw new AppwriteException(`Missing required parameter: "installationId"`);
        auto apiPath = "/apps/{appId}/installations/{installationId}"
            .replace("{appId}", encodeComponent(appId))
            .replace("{installationId}", encodeComponent(installationId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppInstallation)(apiResponse.json);
    }

    /// Delete an installation of an application by its unique ID. Requires a caller
    /// with update access to the app. Previously issued installation access tokens are
    /// revoked.
    void deleteInstallation(string appId, string installationId)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        if (installationId.length == 0)
            throw new AppwriteException(`Missing required parameter: "installationId"`);
        auto apiPath = "/apps/{appId}/installations/{installationId}"
            .replace("{appId}", encodeComponent(appId))
            .replace("{installationId}", encodeComponent(installationId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Create a token for an installation of an application. Requires an app key sent
    /// in the `X-Appwrite-Key` header alongside the `X-Appwrite-App` header, or a
    /// caller with update access to the app. The returned token carries the scopes and
    /// authorization details granted to the installation, and can be used as an
    /// `Authorization: Bearer` header everywhere OAuth2 access tokens are accepted.
    /// Multiple tokens can be active for the same installation at once; each token
    /// stays valid until it expires or the installation is updated or deleted.
    models.Oauth2Token createInstallationToken(string appId, string installationId)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        if (installationId.length == 0)
            throw new AppwriteException(`Missing required parameter: "installationId"`);
        auto apiPath = "/apps/{appId}/installations/{installationId}/tokens"
            .replace("{appId}", encodeComponent(appId))
            .replace("{installationId}", encodeComponent(installationId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2Token)(apiResponse.json);
    }

    /// List app keys for an application.
    models.AppKeyList listKeys(string appId, string[] queries = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        auto apiPath = "/apps/{appId}/keys"
            .replace("{appId}", encodeComponent(appId));

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppKeyList)(apiResponse.json);
    }

    /// Create a new app key for an application. App keys carry no scopes; send one in
    /// the `X-Appwrite-Key` header alongside the `X-Appwrite-App` header to list the
    /// application's installations and create installation access tokens.
    models.AppKey createKey(string appId)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        auto apiPath = "/apps/{appId}/keys"
            .replace("{appId}", encodeComponent(appId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppKey)(apiResponse.json);
    }

    /// Get an app key by its unique ID.
    models.AppKey getKey(string appId, string keyId)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        if (keyId.length == 0)
            throw new AppwriteException(`Missing required parameter: "keyId"`);
        auto apiPath = "/apps/{appId}/keys/{keyId}"
            .replace("{appId}", encodeComponent(appId))
            .replace("{keyId}", encodeComponent(keyId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppKey)(apiResponse.json);
    }

    /// Delete an app key by its unique ID.
    void deleteKey(string appId, string keyId)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        if (keyId.length == 0)
            throw new AppwriteException(`Missing required parameter: "keyId"`);
        auto apiPath = "/apps/{appId}/keys/{keyId}"
            .replace("{appId}", encodeComponent(appId))
            .replace("{keyId}", encodeComponent(keyId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// List client secrets for an application.
    models.AppSecretList listSecrets(string appId, string[] queries = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        auto apiPath = "/apps/{appId}/secrets"
            .replace("{appId}", encodeComponent(appId));

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppSecretList)(apiResponse.json);
    }

    /// Create a new client secret for an application.
    models.AppSecretPlaintext createSecret(string appId)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        auto apiPath = "/apps/{appId}/secrets"
            .replace("{appId}", encodeComponent(appId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppSecretPlaintext)(apiResponse.json);
    }

    /// Get an application client secret by its unique ID.
    models.AppSecret getSecret(string appId, string secretId)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        if (secretId.length == 0)
            throw new AppwriteException(`Missing required parameter: "secretId"`);
        auto apiPath = "/apps/{appId}/secrets/{secretId}"
            .replace("{appId}", encodeComponent(appId))
            .replace("{secretId}", encodeComponent(secretId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppSecret)(apiResponse.json);
    }

    /// Delete an application client secret by its unique ID.
    void deleteSecret(string appId, string secretId)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        if (secretId.length == 0)
            throw new AppwriteException(`Missing required parameter: "secretId"`);
        auto apiPath = "/apps/{appId}/secrets/{secretId}"
            .replace("{appId}", encodeComponent(appId))
            .replace("{secretId}", encodeComponent(secretId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Transfer an application to another team by its unique ID.
    models.App updateTeam(string appId, string teamId)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        auto apiPath = "/apps/{appId}/team"
            .replace("{appId}", encodeComponent(appId));

        JSONValue[string] apiParams;
        apiParams["teamId"] = serialize(teamId);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.App)(apiResponse.json);
    }

    /// Revoke all tokens for an application by its unique ID.
    void deleteTokens(string appId)
    {
        if (appId.length == 0)
            throw new AppwriteException(`Missing required parameter: "appId"`);
        auto apiPath = "/apps/{appId}/tokens"
            .replace("{appId}", encodeComponent(appId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }
}
