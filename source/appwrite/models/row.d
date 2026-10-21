module appwrite.models.row;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Row
struct Row
{
    /// Row ID.
    @jsonKey("$id") string id;

    /// Row sequence ID.
    @jsonKey("$sequence") string sequence;

    /// Table ID.
    @jsonKey("$tableId") string tableId;

    /// Database ID.
    @jsonKey("$databaseId") string databaseId;

    /// Row creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Row update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// Row permissions. [Learn more about
    /// permissions](https://appwrite.io/docs/permissions).
    @jsonKey("$permissions") string[] permissions;

    /// The whole JSON object, including attributes not declared above (such as your own columns).
    @jsonExtra JSONValue data;

    /// Parse a `Row` from JSON.
    static Row fromJson(JSONValue json)
    {
        return deserialize!(Row)(json);
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
