module appwrite.models.document;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Document
struct Document
{
    /// Document ID.
    @jsonKey("$id") string id;

    /// Document sequence ID.
    @jsonKey("$sequence") string sequence;

    /// Collection ID.
    @jsonKey("$collectionId") string collectionId;

    /// Database ID.
    @jsonKey("$databaseId") string databaseId;

    /// Document creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Document update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// Document permissions. [Learn more about
    /// permissions](https://appwrite.io/docs/permissions).
    @jsonKey("$permissions") string[] permissions;

    /// The whole JSON object, including attributes not declared above (such as your own columns).
    @jsonExtra JSONValue data;

    /// Parse a `Document` from JSON.
    static Document fromJson(JSONValue json)
    {
        return deserialize!(Document)(json);
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
