module appwrite.models.team_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Teams List
struct TeamList
{
    /// Total number of teams that matched your query.
    @jsonKey("total") long total;

    /// List of teams.
    @jsonKey("teams") models.Team[] teams;

    /// Parse a `TeamList` from JSON.
    static TeamList fromJson(JSONValue json)
    {
        return deserialize!(TeamList)(json);
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
