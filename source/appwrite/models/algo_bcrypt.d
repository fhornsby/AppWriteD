module appwrite.models.algo_bcrypt;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// AlgoBcrypt
struct AlgoBcrypt
{
    /// Algo type.
    @jsonKey("type") string type = "bcrypt";

    /// Parse a `AlgoBcrypt` from JSON.
    static AlgoBcrypt fromJson(JSONValue json)
    {
        return deserialize!(AlgoBcrypt)(json);
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
