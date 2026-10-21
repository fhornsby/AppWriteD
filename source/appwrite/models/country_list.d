module appwrite.models.country_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Countries List
struct CountryList
{
    /// Total number of countries that matched your query.
    @jsonKey("total") long total;

    /// List of countries.
    @jsonKey("countries") models.Country[] countries;

    /// Parse a `CountryList` from JSON.
    static CountryList fromJson(JSONValue json)
    {
        return deserialize!(CountryList)(json);
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
