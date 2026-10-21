module appwrite.models.algo_sha;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// AlgoSHA
struct AlgoSha
{
    /// Algo type.
    @jsonKey("type") string type = "sha";

    /// Parse a `AlgoSha` from JSON.
    static AlgoSha fromJson(JSONValue json)
    {
        return deserialize!(AlgoSha)(json);
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
