module appwrite.models.algo_md5;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// AlgoMD5
struct AlgoMd5
{
    /// Algo type.
    @jsonKey("type") string type = "md5";

    /// Parse a `AlgoMd5` from JSON.
    static AlgoMd5 fromJson(JSONValue json)
    {
        return deserialize!(AlgoMd5)(json);
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
