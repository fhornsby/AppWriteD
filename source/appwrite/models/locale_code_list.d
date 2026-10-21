module appwrite.models.locale_code_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Locale codes list
struct LocaleCodeList
{
    /// Total number of localeCodes that matched your query.
    @jsonKey("total") long total;

    /// List of localeCodes.
    @jsonKey("localeCodes") models.LocaleCode[] localeCodes;

    /// Parse a `LocaleCodeList` from JSON.
    static LocaleCodeList fromJson(JSONValue json)
    {
        return deserialize!(LocaleCodeList)(json);
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
