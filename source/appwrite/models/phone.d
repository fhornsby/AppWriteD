module appwrite.models.phone;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Phone
struct Phone
{
    /// Phone code.
    @jsonKey("code") string code;

    /// Country two-character ISO 3166-1 alpha code.
    @jsonKey("countryCode") string countryCode;

    /// Country name.
    @jsonKey("countryName") string countryName;

    /// Parse a `Phone` from JSON.
    static Phone fromJson(JSONValue json)
    {
        return deserialize!(Phone)(json);
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
