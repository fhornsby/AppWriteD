module appwrite.models.app_secret_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// App secrets list
struct AppSecretList
{
    /// Total number of secrets that matched your query.
    @jsonKey("total") long total;

    /// List of secrets.
    @jsonKey("secrets") models.AppSecret[] secrets;

    /// Parse a `AppSecretList` from JSON.
    static AppSecretList fromJson(JSONValue json)
    {
        return deserialize!(AppSecretList)(json);
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
