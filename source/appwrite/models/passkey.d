module appwrite.models.passkey;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Passkey
struct Passkey
{
    /// Passkey ID.
    @jsonKey("$id") string id;

    /// Passkey creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Passkey update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// Passkey name.
    @jsonKey("name") string name;

    /// Most recent sign-in with this passkey in ISO 8601 format. Empty until the
    /// passkey is used to sign in.
    @jsonKey("accessedAt") string accessedAt;

    /// Parse a `Passkey` from JSON.
    static Passkey fromJson(JSONValue json)
    {
        return deserialize!(Passkey)(json);
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
