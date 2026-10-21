module appwrite.models.oauth2_project_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 accessible projects list
struct Oauth2ProjectList
{
    /// Total number of projects that matched your query.
    @jsonKey("total") long total;

    /// List of projects.
    @jsonKey("projects") models.Oauth2Project[] projects;

    /// Parse a `Oauth2ProjectList` from JSON.
    static Oauth2ProjectList fromJson(JSONValue json)
    {
        return deserialize!(Oauth2ProjectList)(json);
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
