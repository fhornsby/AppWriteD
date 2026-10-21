module appwrite.models.oauth2_grant;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 Grant
struct Oauth2Grant
{
    /// Grant ID.
    @jsonKey("$id") string id;

    /// Grant creation time in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Grant update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// ID of the user the grant belongs to.
    @jsonKey("userId") string userId;

    /// ID of the OAuth2 client (app) the grant was requested for.
    @jsonKey("appId") string appId;

    /// Requested OAuth2 scopes the user is being asked to consent to.
    @jsonKey("scopes") string[] scopes;

    /// Requested RFC 8707 resource indicators the user is being asked to consent to.
    @jsonKey("resources") string[] resources;

    /// Requested authorization_details the user is being asked to consent to, as a JSON
    /// string. Each entry has a `type` plus project-defined fields.
    @jsonKey("authorizationDetails") string authorizationDetails = "[]";

    /// OIDC prompt directive the consent screen should honor. Space-separated list of:
    /// login, consent, select_account.
    @jsonKey("prompt") string prompt;

    /// Redirect URI the user will be sent to after the flow completes.
    @jsonKey("redirectUri") string redirectUri;

    /// Unix timestamp of when the user last authenticated.
    @jsonKey("authTime") long authTime;

    /// Grant expiration time in ISO 8601 format.
    @jsonKey("expire") string expire;

    /// Parse a `Oauth2Grant` from JSON.
    static Oauth2Grant fromJson(JSONValue json)
    {
        return deserialize!(Oauth2Grant)(json);
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
