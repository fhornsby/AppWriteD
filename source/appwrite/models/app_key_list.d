module appwrite.models.app_key_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// App keys list
struct AppKeyList
{
    /// Total number of keys that matched your query.
    @jsonKey("total") long total;

    /// List of keys.
    @jsonKey("keys") models.AppKey[] keys;

    /// Parse a `AppKeyList` from JSON.
    static AppKeyList fromJson(JSONValue json)
    {
        return deserialize!(AppKeyList)(json);
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
