module appwrite.models.oauth2_consent;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 Consent
struct Oauth2Consent
{
    /// Consent ID.
    @jsonKey("$id") string id;

    /// Consent creation time in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Consent update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// ID of the user the consent belongs to.
    @jsonKey("userId") string userId;

    /// ID of the registered app the consent was given to. Empty for URL-form (CIMD)
    /// clients.
    @jsonKey("appId") string appId;

    /// Client ID metadata document URL of the client the consent was given to. Empty
    /// for registered apps.
    @jsonKey("cimdUrl") string cimdUrl;

    /// OAuth2 scopes the user consented to.
    @jsonKey("scopes") string[] scopes;

    /// RFC 8707 resource indicators the user consented to.
    @jsonKey("resources") string[] resources;

    /// Authorization details the user consented to, as a JSON string. Each entry has a
    /// `type` plus project-defined fields.
    @jsonKey("authorizationDetails") string authorizationDetails = "[]";

    /// Consent expiration time in ISO 8601 format. Empty when the consent has no
    /// token-bound expiry yet.
    @jsonKey("expire") string expire;

    /// Parse a `Oauth2Consent` from JSON.
    static Oauth2Consent fromJson(JSONValue json)
    {
        return deserialize!(Oauth2Consent)(json);
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
