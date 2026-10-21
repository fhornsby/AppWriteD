module appwrite.models.oauth2_project;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 Project
struct Oauth2Project
{
    /// Project ID.
    @jsonKey("$id") string id;

    /// Region ID the project is deployed in.
    @jsonKey("region") string region;

    /// API endpoint of the region the project is deployed in. Empty when the region has
    /// no public hostname configured.
    @jsonKey("endpoint") string endpoint;

    /// Parse a `Oauth2Project` from JSON.
    static Oauth2Project fromJson(JSONValue json)
    {
        return deserialize!(Oauth2Project)(json);
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
