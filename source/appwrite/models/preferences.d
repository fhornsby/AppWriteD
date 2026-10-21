module appwrite.models.preferences;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Preferences
struct Preferences
{
    /// The whole JSON object, including attributes not declared above (such as your own columns).
    @jsonExtra JSONValue data;

    /// Parse a `Preferences` from JSON.
    static Preferences fromJson(JSONValue json)
    {
        return deserialize!(Preferences)(json);
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

    /// The attribute `key` from the full JSON object, or a null JSONValue when absent.
    JSONValue opIndex(string key)
    {
        if (data.type != JSONType.object)
            return JSONValue.init;
        if (auto value = key in data)
            return *value;
        return JSONValue.init;
    }

    /// Convert the full JSON object to your own type, e.g. a struct describing your columns.
    T convertTo(T)()
    {
        return deserialize!T(data);
    }
}
