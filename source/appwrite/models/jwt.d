module appwrite.models.jwt;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// JWT
struct Jwt
{
    /// JWT encoded string.
    @jsonKey("jwt") string jwt;

    /// Parse a `Jwt` from JSON.
    static Jwt fromJson(JSONValue json)
    {
        return deserialize!(Jwt)(json);
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
