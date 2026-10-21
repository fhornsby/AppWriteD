module appwrite.models.phone_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Phones List
struct PhoneList
{
    /// Total number of phones that matched your query.
    @jsonKey("total") long total;

    /// List of phones.
    @jsonKey("phones") models.Phone[] phones;

    /// Parse a `PhoneList` from JSON.
    static PhoneList fromJson(JSONValue json)
    {
        return deserialize!(PhoneList)(json);
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
