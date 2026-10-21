module appwrite.models.algo_phpass;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// AlgoPHPass
struct AlgoPhpass
{
    /// Algo type.
    @jsonKey("type") string type = "phpass";

    /// Parse a `AlgoPhpass` from JSON.
    static AlgoPhpass fromJson(JSONValue json)
    {
        return deserialize!(AlgoPhpass)(json);
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
