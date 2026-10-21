module appwrite.models.headers;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Headers
struct Headers
{
    /// Header name.
    @jsonKey("name") string name;

    /// Header value.
    @jsonKey("value") string value;

    /// Parse a `Headers` from JSON.
    static Headers fromJson(JSONValue json)
    {
        return deserialize!(Headers)(json);
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
