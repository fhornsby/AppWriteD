module appwrite.models.app_secret;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// AppSecret
struct AppSecret
{
    /// Secret ID.
    @jsonKey("$id") string id;

    /// Secret creation time in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Secret update time in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// Application ID this secret belongs to.
    @jsonKey("appId") string appId;

    /// Always empty. The application client secret is returned only once, in the
    /// response of the createSecret method.
    @jsonKey("secret") string secret;

    /// Last few characters of the client secret, used to help identify it.
    @jsonKey("hint") string hint;

    /// ID of the user who created the secret.
    @jsonKey("createdById") string createdById;

    /// Name of the user who created the secret.
    @jsonKey("createdByName") string createdByName;

    /// Time the secret was last used for authentication in ISO 8601 format. Null if
    /// never used.
    @jsonKey("lastAccessedAt") string lastAccessedAt;

    /// Parse a `AppSecret` from JSON.
    static AppSecret fromJson(JSONValue json)
    {
        return deserialize!(AppSecret)(json);
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
