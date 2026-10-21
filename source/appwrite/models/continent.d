module appwrite.models.continent;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Continent
struct Continent
{
    /// Continent name.
    @jsonKey("name") string name;

    /// Continent two letter code.
    @jsonKey("code") string code;

    /// Parse a `Continent` from JSON.
    static Continent fromJson(JSONValue json)
    {
        return deserialize!(Continent)(json);
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
