module appwrite.models.algo_scrypt_modified;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// AlgoScryptModified
struct AlgoScryptModified
{
    /// Algo type.
    @jsonKey("type") string type = "scryptMod";

    /// Salt used to compute hash.
    @jsonKey("salt") string salt;

    /// Separator used to compute hash.
    @jsonKey("saltSeparator") string saltSeparator;

    /// Key used to compute hash.
    @jsonKey("signerKey") string signerKey;

    /// Parse a `AlgoScryptModified` from JSON.
    static AlgoScryptModified fromJson(JSONValue json)
    {
        return deserialize!(AlgoScryptModified)(json);
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
