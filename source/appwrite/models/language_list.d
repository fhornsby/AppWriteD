module appwrite.models.language_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Languages List
struct LanguageList
{
    /// Total number of languages that matched your query.
    @jsonKey("total") long total;

    /// List of languages.
    @jsonKey("languages") models.Language[] languages;

    /// Parse a `LanguageList` from JSON.
    static LanguageList fromJson(JSONValue json)
    {
        return deserialize!(LanguageList)(json);
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
