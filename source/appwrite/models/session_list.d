module appwrite.models.session_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Sessions List
struct SessionList
{
    /// Total number of sessions that matched your query.
    @jsonKey("total") long total;

    /// List of sessions.
    @jsonKey("sessions") models.Session[] sessions;

    /// Parse a `SessionList` from JSON.
    static SessionList fromJson(JSONValue json)
    {
        return deserialize!(SessionList)(json);
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
