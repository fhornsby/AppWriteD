module appwrite.models.team;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Team
struct Team
{
    /// Team ID.
    @jsonKey("$id") string id;

    /// Team creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Team update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// Team name.
    @jsonKey("name") string name;

    /// Total number of team members.
    @jsonKey("total") long total;

    /// Team preferences as a key-value object
    @jsonKey("prefs") models.Preferences prefs;

    /// Parse a `Team` from JSON.
    static Team fromJson(JSONValue json)
    {
        return deserialize!(Team)(json);
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
