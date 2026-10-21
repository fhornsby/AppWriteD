module appwrite.models.algo_argon2;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// AlgoArgon2
struct AlgoArgon2
{
    /// Algo type.
    @jsonKey("type") string type = "argon2";

    /// Memory used to compute hash.
    @jsonKey("memoryCost") long memoryCost;

    /// Amount of time consumed to compute hash
    @jsonKey("timeCost") long timeCost;

    /// Number of threads used to compute hash.
    @jsonKey("threads") long threads;

    /// Parse a `AlgoArgon2` from JSON.
    static AlgoArgon2 fromJson(JSONValue json)
    {
        return deserialize!(AlgoArgon2)(json);
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
