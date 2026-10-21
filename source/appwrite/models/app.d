module appwrite.models.app;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// App
struct App
{
    /// App ID.
    @jsonKey("$id") string id;

    /// App creation time in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// App update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// Application name.
    @jsonKey("name") string name;

    /// Application description shown to users during OAuth2 consent.
    @jsonKey("description") string description;

    /// Application homepage URL shown to users during OAuth2 consent.
    @jsonKey("clientUri") string clientUri;

    /// Application logo URL shown to users during OAuth2 consent.
    @jsonKey("logoUri") string logoUri;

    /// Application privacy policy URL shown to users during OAuth2 consent.
    @jsonKey("privacyPolicyUrl") string privacyPolicyUrl;

    /// Application terms of service URL shown to users during OAuth2 consent.
    @jsonKey("termsUrl") string termsUrl;

    /// Application support or security contact emails.
    @jsonKey("contacts") string[] contacts;

    /// Application tagline shown to users during OAuth2 consent.
    @jsonKey("tagline") string tagline;

    /// Application tags shown to users during OAuth2 consent.
    @jsonKey("tags") string[] tags;

    /// Application labels. Read-only for clients; only a server SDK using a project API
    /// key can update them.
    @jsonKey("labels") string[] labels;

    /// Application image URLs shown to users during OAuth2 consent.
    @jsonKey("images") string[] images;

    /// Application support URL shown to users during OAuth2 consent.
    @jsonKey("supportUrl") string supportUrl;

    /// Application data deletion URL shown to users during OAuth2 consent.
    @jsonKey("dataDeletionUrl") string dataDeletionUrl;

    /// List of authorized redirect URIs. These URIs can be used to redirect users after
    /// they authenticate.
    @jsonKey("redirectUris") string[] redirectUris;

    /// List of authorized post-logout redirect URIs for OpenID Connect RP-Initiated
    /// Logout. The logout endpoint only redirects users to URIs in this list after
    /// ending their session.
    @jsonKey("postLogoutRedirectUris") string[] postLogoutRedirectUris;

    /// Whether the app is enabled or not.
    @jsonKey("enabled") bool enabled = true;

    /// OAuth2 client type. `public` for SPAs, mobile, and native apps that cannot keep
    /// a client secret (PKCE required); `confidential` for server-side clients that
    /// authenticate with a client secret.
    @jsonKey("type") string type = "confidential";

    /// Whether this client may use the OAuth2 Device Authorization Grant (RFC 8628).
    @jsonKey("deviceFlow") bool deviceFlow = false;

    /// ID of team that owns the application, if owned by team. Otherwise, user ID will
    /// be used.
    @jsonKey("teamId") string teamId;

    /// ID of user who owns the application, if owned by user. Otherwise, team ID will
    /// be used.
    @jsonKey("userId") string userId;

    /// Scopes the application requests when installed on a team. Organization-level and
    /// project-level scopes only.
    @jsonKey("installationScopes") string[] installationScopes;

    /// URL users are redirected to after creating or updating an installation of this
    /// application. Empty for no redirect.
    @jsonKey("installationRedirectUrl") string installationRedirectUrl;

    /// List of application secrets.
    @jsonKey("secrets") models.AppSecret[] secrets;

    /// Parse a `App` from JSON.
    static App fromJson(JSONValue json)
    {
        return deserialize!(App)(json);
    }

    /// Convert to JSON.
    JSONValue toJson()
    {
        return serialize(this);
    }

    /// JSON text of this model.
    string toString()
    {
        return toJSONString(toJson());
    }
}
