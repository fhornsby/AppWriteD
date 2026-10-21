module appwrite.models.app_key;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// AppKey
struct AppKey
{
    /// App key ID.
    @jsonKey("$id") string id;

    /// App key creation time in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// App key update time in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// Application ID this app key belongs to.
    @jsonKey("appId") string appId;

    /// App key secret.
    @jsonKey("secret") string secret;

    /// Last few characters of the app key secret, used to help identify it.
    @jsonKey("hint") string hint;

    /// ID of the user who created the app key.
    @jsonKey("createdById") string createdById;

    /// Name of the user who created the app key.
    @jsonKey("createdByName") string createdByName;

    /// Time the app key was last used for authentication in ISO 8601 format. Null if
    /// never used.
    @jsonKey("lastAccessedAt") string lastAccessedAt;

    /// Parse a `AppKey` from JSON.
    static AppKey fromJson(JSONValue json)
    {
        return deserialize!(AppKey)(json);
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
