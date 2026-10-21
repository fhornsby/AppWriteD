module appwrite.models.oauth2_organization;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 Organization
struct Oauth2Organization
{
    /// Organization ID.
    @jsonKey("$id") string id;

    /// Parse a `Oauth2Organization` from JSON.
    static Oauth2Organization fromJson(JSONValue json)
    {
        return deserialize!(Oauth2Organization)(json);
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
