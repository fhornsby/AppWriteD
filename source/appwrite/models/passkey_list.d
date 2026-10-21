module appwrite.models.passkey_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Passkeys List
struct PasskeyList
{
    /// Total number of passkeys that matched your query.
    @jsonKey("total") long total;

    /// List of passkeys.
    @jsonKey("passkeys") models.Passkey[] passkeys;

    /// Parse a `PasskeyList` from JSON.
    static PasskeyList fromJson(JSONValue json)
    {
        return deserialize!(PasskeyList)(json);
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
