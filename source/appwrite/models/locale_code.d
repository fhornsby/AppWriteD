module appwrite.models.locale_code;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// LocaleCode
struct LocaleCode
{
    /// Locale codes in [ISO
    /// 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
    @jsonKey("code") string code;

    /// Locale name
    @jsonKey("name") string name;

    /// Parse a `LocaleCode` from JSON.
    static LocaleCode fromJson(JSONValue json)
    {
        return deserialize!(LocaleCode)(json);
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
