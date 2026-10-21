module appwrite.models.target;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Target
struct Target
{
    /// Target ID.
    @jsonKey("$id") string id;

    /// Target creation time in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Target update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// Target Name.
    @jsonKey("name") string name;

    /// User ID.
    @jsonKey("userId") string userId;

    /// Provider ID.
    @jsonKey("providerId") string providerId;

    /// The target provider type. Can be one of the following: `email`, `sms` or `push`.
    @jsonKey("providerType") string providerType;

    /// The target identifier.
    @jsonKey("identifier") string identifier;

    /// Is the target expired.
    @jsonKey("expired") bool expired = false;

    /// Parse a `Target` from JSON.
    static Target fromJson(JSONValue json)
    {
        return deserialize!(Target)(json);
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
