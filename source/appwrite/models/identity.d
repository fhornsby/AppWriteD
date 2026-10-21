module appwrite.models.identity;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Identity
struct Identity
{
    /// Identity ID.
    @jsonKey("$id") string id;

    /// Identity creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Identity update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// User ID.
    @jsonKey("userId") string userId;

    /// Identity Provider.
    @jsonKey("provider") string provider;

    /// ID of the User in the Identity Provider.
    @jsonKey("providerUid") string providerUid;

    /// Email of the User in the Identity Provider.
    @jsonKey("providerEmail") string providerEmail;

    /// Identity Provider Access Token.
    @jsonKey("providerAccessToken") string providerAccessToken;

    /// The date of when the access token expires in ISO 8601 format.
    @jsonKey("providerAccessTokenExpiry") string providerAccessTokenExpiry;

    /// Identity Provider Refresh Token.
    @jsonKey("providerRefreshToken") string providerRefreshToken;

    /// Identity Provider ID token (JWT) from the most recent native sign-in. Empty for
    /// identities created through the browser OAuth2 flow.
    @jsonKey("providerIdToken") string providerIdToken;

    /// Parse a `Identity` from JSON.
    static Identity fromJson(JSONValue json)
    {
        return deserialize!(Identity)(json);
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
