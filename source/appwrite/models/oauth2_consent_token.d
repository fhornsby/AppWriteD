module appwrite.models.oauth2_consent_token;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 Consent Token
struct Oauth2ConsentToken
{
    /// Token family ID.
    @jsonKey("$id") string id;

    /// Token creation time in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Token update date in ISO 8601 format. Refreshing the token family updates this.
    @jsonKey("$updatedAt") string updatedAt;

    /// ID of the consent the token family was issued under.
    @jsonKey("consentId") string consentId;

    /// ID of the user the token family belongs to.
    @jsonKey("userId") string userId;

    /// ID of the registered app the token family was issued to. Empty for URL-form
    /// (CIMD) clients.
    @jsonKey("appId") string appId;

    /// Client ID metadata document URL of the client the token family was issued to.
    /// Empty for registered apps.
    @jsonKey("cimdUrl") string cimdUrl;

    /// OAuth2 scopes granted on the token family.
    @jsonKey("scopes") string[] scopes;

    /// RFC 8707 resource indicators granted on the token family.
    @jsonKey("resources") string[] resources;

    /// Authorization details granted on the token family, as a JSON string. Each entry
    /// has a `type` plus project-defined fields.
    @jsonKey("authorizationDetails") string authorizationDetails = "[]";

    /// Expiration time of the current access token of this family in ISO 8601 format.
    @jsonKey("expire") string expire;

    /// Parse a `Oauth2ConsentToken` from JSON.
    static Oauth2ConsentToken fromJson(JSONValue json)
    {
        return deserialize!(Oauth2ConsentToken)(json);
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
