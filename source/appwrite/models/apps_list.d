module appwrite.models.apps_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Apps list
struct AppsList
{
    /// Total number of apps that matched your query.
    @jsonKey("total") long total;

    /// List of apps.
    @jsonKey("apps") models.App[] apps;

    /// Parse a `AppsList` from JSON.
    static AppsList fromJson(JSONValue json)
    {
        return deserialize!(AppsList)(json);
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
