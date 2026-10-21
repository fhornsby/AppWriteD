module appwrite.models.language;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Language
struct Language
{
    /// Language name.
    @jsonKey("name") string name;

    /// Language two-character ISO 639-1 codes.
    @jsonKey("code") string code;

    /// Language native name.
    @jsonKey("nativeName") string nativeName;

    /// Parse a `Language` from JSON.
    static Language fromJson(JSONValue json)
    {
        return deserialize!(Language)(json);
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
