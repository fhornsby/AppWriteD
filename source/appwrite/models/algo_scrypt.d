module appwrite.models.algo_scrypt;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// AlgoScrypt
struct AlgoScrypt
{
    /// Algo type.
    @jsonKey("type") string type = "scrypt";

    /// CPU complexity of computed hash.
    @jsonKey("costCpu") long costCpu = 8;

    /// Memory complexity of computed hash.
    @jsonKey("costMemory") long costMemory = 14;

    /// Parallelization of computed hash.
    @jsonKey("costParallel") long costParallel = 1;

    /// Length used to compute hash.
    @jsonKey("length") long length = 64;

    /// Parse a `AlgoScrypt` from JSON.
    static AlgoScrypt fromJson(JSONValue json)
    {
        return deserialize!(AlgoScrypt)(json);
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
