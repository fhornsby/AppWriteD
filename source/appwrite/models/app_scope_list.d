module appwrite.models.app_scope_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// App scopes list
struct AppScopeList
{
    /// Total number of scopes that matched your query.
    @jsonKey("total") long total;

    /// List of scopes.
    @jsonKey("scopes") models.AppScope[] scopes;

    /// Parse a `AppScopeList` from JSON.
    static AppScopeList fromJson(JSONValue json)
    {
        return deserialize!(AppScopeList)(json);
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
