module appwrite.models.presence_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Presences List
struct PresenceList
{
    /// Total number of presences that matched your query.
    @jsonKey("total") long total;

    /// List of presences.
    @jsonKey("presences") models.Presence[] presences;

    /// Parse a `PresenceList` from JSON.
    static PresenceList fromJson(JSONValue json)
    {
        return deserialize!(PresenceList)(json);
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
