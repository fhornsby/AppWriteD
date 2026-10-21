module appwrite.models.country;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Country
struct Country
{
    /// Country name.
    @jsonKey("name") string name;

    /// Country two-character ISO 3166-1 alpha code.
    @jsonKey("code") string code;

    /// Parse a `Country` from JSON.
    static Country fromJson(JSONValue json)
    {
        return deserialize!(Country)(json);
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
