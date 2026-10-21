module appwrite.models.continent_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Continents List
struct ContinentList
{
    /// Total number of continents that matched your query.
    @jsonKey("total") long total;

    /// List of continents.
    @jsonKey("continents") models.Continent[] continents;

    /// Parse a `ContinentList` from JSON.
    static ContinentList fromJson(JSONValue json)
    {
        return deserialize!(ContinentList)(json);
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
