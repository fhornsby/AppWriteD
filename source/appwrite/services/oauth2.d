module appwrite.services.oauth2;

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

/// The OAuth2 service allows you to authorize apps and issue standards-based OAuth2
/// and OpenID Connect tokens.
class Oauth2 : Service
{
    this(Client client)
    {
        super(client);
    }

    /// Approve an OAuth2 grant after the user gives consent. Returns the `redirectUrl`
    /// the end user should be sent to. The consent screen may optionally pass enriched
    /// `authorization_details` to record the concrete resources the user selected. You
    /// can pass Accept header of `application/json` to receive a JSON response instead
    /// of a redirect.
    models.Oauth2Approve approve(string grantId, string authorizationDetails = null, string scope_ = null)
    {
        auto apiPath = "/oauth2/{project_id}/approve"
            .replace("{project_id}", encodeComponent(client.config("project")));

        JSONValue[string] apiParams;
        apiParams["grant_id"] = serialize(grantId);
        if (authorizationDetails !is null)
            apiParams["authorization_details"] = serialize(authorizationDetails);
        if (scope_ !is null)
            apiParams["scope"] = serialize(scope_);

        string[string] apiHeaders;
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2Approve)(apiResponse.json);
    }

    /// Begin the OAuth2 authorization flow. When called without a session, the user is
    /// redirected to the consent screen without grant ID. When called with a session,
    /// the redirect URL includes param for grant ID. You can pass Accept header of
    /// `application/json` to receive a JSON response instead of a redirect.
    models.Oauth2Authorize authorize(string clientId = null, string redirectUri = null, string responseType = null, string scope_ = null, string state = null, string nonce = null, string codeChallenge = null, string codeChallengeMethod = null, string prompt = null, long maxAge = unset!long, string authorizationDetails = null, string[] resource = null, string audience = null, string requestUri = null)
    {
        auto apiPath = "/oauth2/{project_id}/authorize"
            .replace("{project_id}", encodeComponent(client.config("project")));

        JSONValue[string] apiParams;
        if (clientId !is null)
            apiParams["client_id"] = serialize(clientId);
        if (redirectUri !is null)
            apiParams["redirect_uri"] = serialize(redirectUri);
        if (responseType !is null)
            apiParams["response_type"] = serialize(responseType);
        if (scope_ !is null)
            apiParams["scope"] = serialize(scope_);
        if (state !is null)
            apiParams["state"] = serialize(state);
        if (nonce !is null)
            apiParams["nonce"] = serialize(nonce);
        if (codeChallenge !is null)
            apiParams["code_challenge"] = serialize(codeChallenge);
        if (codeChallengeMethod !is null)
            apiParams["code_challenge_method"] = serialize(codeChallengeMethod);
        if (prompt !is null)
            apiParams["prompt"] = serialize(prompt);
        if (isSet(maxAge))
            apiParams["max_age"] = serialize(maxAge);
        if (authorizationDetails !is null)
            apiParams["authorization_details"] = serialize(authorizationDetails);
        if (resource !is null)
            apiParams["resource"] = serialize(resource);
        if (audience !is null)
            apiParams["audience"] = serialize(audience);
        if (requestUri !is null)
            apiParams["request_uri"] = serialize(requestUri);

        string[string] apiHeaders;
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2Authorize)(apiResponse.json);
    }

    /// Begin the OAuth2 authorization flow. When called without a session, the user is
    /// redirected to the consent screen without grant ID. When called with a session,
    /// the redirect URL includes param for grant ID. You can pass Accept header of
    /// `application/json` to receive a JSON response instead of a redirect.
    models.Oauth2Authorize authorizePost(string clientId = null, string redirectUri = null, string responseType = null, string scope_ = null, string state = null, string nonce = null, string codeChallenge = null, string codeChallengeMethod = null, string prompt = null, long maxAge = unset!long, string authorizationDetails = null, string[] resource = null, string audience = null, string requestUri = null)
    {
        auto apiPath = "/oauth2/{project_id}/authorize"
            .replace("{project_id}", encodeComponent(client.config("project")));

        JSONValue[string] apiParams;
        if (clientId !is null)
            apiParams["client_id"] = serialize(clientId);
        if (redirectUri !is null)
            apiParams["redirect_uri"] = serialize(redirectUri);
        if (responseType !is null)
            apiParams["response_type"] = serialize(responseType);
        if (scope_ !is null)
            apiParams["scope"] = serialize(scope_);
        if (state !is null)
            apiParams["state"] = serialize(state);
        if (nonce !is null)
            apiParams["nonce"] = serialize(nonce);
        if (codeChallenge !is null)
            apiParams["code_challenge"] = serialize(codeChallenge);
        if (codeChallengeMethod !is null)
            apiParams["code_challenge_method"] = serialize(codeChallengeMethod);
        if (prompt !is null)
            apiParams["prompt"] = serialize(prompt);
        if (isSet(maxAge))
            apiParams["max_age"] = serialize(maxAge);
        if (authorizationDetails !is null)
            apiParams["authorization_details"] = serialize(authorizationDetails);
        if (resource !is null)
            apiParams["resource"] = serialize(resource);
        if (audience !is null)
            apiParams["audience"] = serialize(audience);
        if (requestUri !is null)
            apiParams["request_uri"] = serialize(requestUri);

        string[string] apiHeaders;
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2Authorize)(apiResponse.json);
    }

    /// Start the OAuth2 Device Authorization Grant. Returns the device code, user code,
    /// verification URL, expiration, and polling interval.
    models.Oauth2DeviceAuthorization createDeviceAuthorization(string clientId = null, string scope_ = null, string authorizationDetails = null, string[] resource = null, string audience = null)
    {
        auto apiPath = "/oauth2/{project_id}/device_authorization"
            .replace("{project_id}", encodeComponent(client.config("project")));

        JSONValue[string] apiParams;
        if (clientId !is null)
            apiParams["client_id"] = serialize(clientId);
        if (scope_ !is null)
            apiParams["scope"] = serialize(scope_);
        if (authorizationDetails !is null)
            apiParams["authorization_details"] = serialize(authorizationDetails);
        if (resource !is null)
            apiParams["resource"] = serialize(resource);
        if (audience !is null)
            apiParams["audience"] = serialize(audience);

        string[string] apiHeaders;
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2DeviceAuthorization)(apiResponse.json);
    }

    /// Exchange a device flow user code for an OAuth2 grant. The authenticated user is
    /// bound to the pending grant. Pass the returned grant ID to the get grant endpoint
    /// to render the consent screen, then to the approve or reject endpoint to complete
    /// the flow.
    models.Oauth2Grant createGrant(string userCode)
    {
        auto apiPath = "/oauth2/{project_id}/grants"
            .replace("{project_id}", encodeComponent(client.config("project")));

        JSONValue[string] apiParams;
        apiParams["user_code"] = serialize(userCode);

        string[string] apiHeaders;
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2Grant)(apiResponse.json);
    }

    /// Get an OAuth2 grant by its ID. Used by the consent screen to display the details
    /// of the authorization the user is being asked to approve. A grant can only be
    /// read by the user it belongs to, or by server SDK.
    models.Oauth2Grant getGrant(string grantId)
    {
        if (grantId.length == 0)
            throw new AppwriteException(`Missing required parameter: "grantId"`);
        auto apiPath = "/oauth2/{project_id}/grants/{grant_id}"
            .replace("{project_id}", encodeComponent(client.config("project")))
            .replace("{grant_id}", encodeComponent(grantId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2Grant)(apiResponse.json);
    }

    /// OpenID Connect RP-Initiated Logout. Ends the user session and revokes the tokens
    /// issued to the app identified by the `id_token_hint`, then redirects the user to
    /// `post_logout_redirect_uri` when it matches a URI registered on the app.
    void logout(string idTokenHint = null, string logoutHint = null, string clientId = null, string postLogoutRedirectUri = null, string state = null, string uiLocales = null)
    {
        auto apiPath = "/oauth2/{project_id}/logout"
            .replace("{project_id}", encodeComponent(client.config("project")));

        JSONValue[string] apiParams;
        if (idTokenHint !is null)
            apiParams["id_token_hint"] = serialize(idTokenHint);
        if (logoutHint !is null)
            apiParams["logout_hint"] = serialize(logoutHint);
        if (clientId !is null)
            apiParams["client_id"] = serialize(clientId);
        if (postLogoutRedirectUri !is null)
            apiParams["post_logout_redirect_uri"] = serialize(postLogoutRedirectUri);
        if (state !is null)
            apiParams["state"] = serialize(state);
        if (uiLocales !is null)
            apiParams["ui_locales"] = serialize(uiLocales);

        string[string] apiHeaders;
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// OpenID Connect RP-Initiated Logout. Ends the user session and revokes the tokens
    /// issued to the app identified by the `id_token_hint`, then redirects the user to
    /// `post_logout_redirect_uri` when it matches a URI registered on the app.
    void logoutPost(string idTokenHint = null, string logoutHint = null, string clientId = null, string postLogoutRedirectUri = null, string state = null, string uiLocales = null)
    {
        auto apiPath = "/oauth2/{project_id}/logout"
            .replace("{project_id}", encodeComponent(client.config("project")));

        JSONValue[string] apiParams;
        if (idTokenHint !is null)
            apiParams["id_token_hint"] = serialize(idTokenHint);
        if (logoutHint !is null)
            apiParams["logout_hint"] = serialize(logoutHint);
        if (clientId !is null)
            apiParams["client_id"] = serialize(clientId);
        if (postLogoutRedirectUri !is null)
            apiParams["post_logout_redirect_uri"] = serialize(postLogoutRedirectUri);
        if (state !is null)
            apiParams["state"] = serialize(state);
        if (uiLocales !is null)
            apiParams["ui_locales"] = serialize(uiLocales);

        string[string] apiHeaders;
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// List the organizations the OAuth2 access token can access. Resolves the token's
    /// `organization` authorization details, expanding the `*` wildcard into the
    /// concrete set of organizations the user can see.
    models.Oauth2OrganizationList listOrganizations(long limit = unset!long, long offset = unset!long, string search = null)
    {
        auto apiPath = "/oauth2/{project_id}/organizations"
            .replace("{project_id}", encodeComponent(client.config("project")));

        JSONValue[string] apiParams;
        if (isSet(limit))
            apiParams["limit"] = serialize(limit);
        if (isSet(offset))
            apiParams["offset"] = serialize(offset);
        if (search !is null)
            apiParams["search"] = serialize(search);

        string[string] apiHeaders;
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2OrganizationList)(apiResponse.json);
    }

    /// Store an OAuth2 authorization request server-side and receive a short-lived
    /// request_uri handle for the authorize endpoint.
    models.Oauth2PAR createPAR(string clientId, string redirectUri, string responseType, string scope_ = null, string state = null, string nonce = null, string codeChallenge = null, string codeChallengeMethod = null, string prompt = null, long maxAge = unset!long, string authorizationDetails = null, string[] resource = null, string audience = null)
    {
        auto apiPath = "/oauth2/{project_id}/par"
            .replace("{project_id}", encodeComponent(client.config("project")));

        JSONValue[string] apiParams;
        apiParams["client_id"] = serialize(clientId);
        apiParams["redirect_uri"] = serialize(redirectUri);
        apiParams["response_type"] = serialize(responseType);
        if (scope_ !is null)
            apiParams["scope"] = serialize(scope_);
        if (state !is null)
            apiParams["state"] = serialize(state);
        if (nonce !is null)
            apiParams["nonce"] = serialize(nonce);
        if (codeChallenge !is null)
            apiParams["code_challenge"] = serialize(codeChallenge);
        if (codeChallengeMethod !is null)
            apiParams["code_challenge_method"] = serialize(codeChallengeMethod);
        if (prompt !is null)
            apiParams["prompt"] = serialize(prompt);
        if (isSet(maxAge))
            apiParams["max_age"] = serialize(maxAge);
        if (authorizationDetails !is null)
            apiParams["authorization_details"] = serialize(authorizationDetails);
        if (resource !is null)
            apiParams["resource"] = serialize(resource);
        if (audience !is null)
            apiParams["audience"] = serialize(audience);

        string[string] apiHeaders;
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2PAR)(apiResponse.json);
    }

    /// List the projects the OAuth2 access token can access. Resolves the token's
    /// `project` authorization details, expanding the `*` wildcard into the concrete
    /// set of projects the user can see.
    models.Oauth2ProjectList listProjects(long limit = unset!long, long offset = unset!long, string search = null)
    {
        auto apiPath = "/oauth2/{project_id}/projects"
            .replace("{project_id}", encodeComponent(client.config("project")));

        JSONValue[string] apiParams;
        if (isSet(limit))
            apiParams["limit"] = serialize(limit);
        if (isSet(offset))
            apiParams["offset"] = serialize(offset);
        if (search !is null)
            apiParams["search"] = serialize(search);

        string[string] apiHeaders;
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2ProjectList)(apiResponse.json);
    }

    /// Reject an OAuth2 grant when the user denies consent. Returns the `redirectUrl`
    /// the end user should be sent to with an `access_denied` error. You can pass
    /// Accept header of `application/json` to receive a JSON response instead of a
    /// redirect.
    models.Oauth2Reject reject(string grantId)
    {
        auto apiPath = "/oauth2/{project_id}/reject"
            .replace("{project_id}", encodeComponent(client.config("project")));

        JSONValue[string] apiParams;
        apiParams["grant_id"] = serialize(grantId);

        string[string] apiHeaders;
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2Reject)(apiResponse.json);
    }

    /// Revoke an OAuth2 access token or refresh token.
    JSONValue revoke(string token, string tokenTypeHint = null, string clientId = null, string clientSecret = null)
    {
        auto apiPath = "/oauth2/{project_id}/revoke"
            .replace("{project_id}", encodeComponent(client.config("project")));

        JSONValue[string] apiParams;
        apiParams["token"] = serialize(token);
        if (tokenTypeHint !is null)
            apiParams["token_type_hint"] = serialize(tokenTypeHint);
        if (clientId !is null)
            apiParams["client_id"] = serialize(clientId);
        if (clientSecret !is null)
            apiParams["client_secret"] = serialize(clientSecret);

        string[string] apiHeaders;
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return apiResponse.json;
    }

    /// Exchange an OAuth2 authorization code, refresh token, or device code for access
    /// and refresh tokens.
    models.Oauth2Token createToken(string grantType, string code = null, string refreshToken = null, string deviceCode = null, string clientId = null, string clientSecret = null, string codeVerifier = null, string redirectUri = null, string[] resource = null, string audience = null)
    {
        auto apiPath = "/oauth2/{project_id}/token"
            .replace("{project_id}", encodeComponent(client.config("project")));

        JSONValue[string] apiParams;
        apiParams["grant_type"] = serialize(grantType);
        if (code !is null)
            apiParams["code"] = serialize(code);
        if (refreshToken !is null)
            apiParams["refresh_token"] = serialize(refreshToken);
        if (deviceCode !is null)
            apiParams["device_code"] = serialize(deviceCode);
        if (clientId !is null)
            apiParams["client_id"] = serialize(clientId);
        if (clientSecret !is null)
            apiParams["client_secret"] = serialize(clientSecret);
        if (codeVerifier !is null)
            apiParams["code_verifier"] = serialize(codeVerifier);
        if (redirectUri !is null)
            apiParams["redirect_uri"] = serialize(redirectUri);
        if (resource !is null)
            apiParams["resource"] = serialize(resource);
        if (audience !is null)
            apiParams["audience"] = serialize(audience);

        string[string] apiHeaders;
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2Token)(apiResponse.json);
    }
}
