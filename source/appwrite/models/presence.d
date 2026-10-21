module appwrite.models.presence;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Presence
struct Presence
{
    /// Presence ID.
    @jsonKey("$id") string id;

    /// Presence creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Presence update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// Presence permissions. [Learn more about
    /// permissions](https://appwrite.io/docs/permissions).
    @jsonKey("$permissions") string[] permissions;

    /// User ID.
    @jsonKey("userId") string userId;

    /// Presence status.
    @jsonKey("status") string status;

    /// Presence source.
    @jsonKey("source") string source;

    /// Presence expiry date in ISO 8601 format.
    @jsonKey("expiresAt") string expiresAt;

    /// Presence metadata.
    @jsonKey("metadata") JSONValue metadata;

    /// Parse a `Presence` from JSON.
    static Presence fromJson(JSONValue json)
    {
        return deserialize!(Presence)(json);
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
