module appwrite.models.mfa_challenge;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// MFA Challenge
struct MfaChallenge
{
    /// Token ID.
    @jsonKey("$id") string id;

    /// Token creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// User ID.
    @jsonKey("userId") string userId;

    /// Token expiration date in ISO 8601 format.
    @jsonKey("expire") string expire;

    /// Parse a `MfaChallenge` from JSON.
    static MfaChallenge fromJson(JSONValue json)
    {
        return deserialize!(MfaChallenge)(json);
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
