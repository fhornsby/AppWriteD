module appwrite.models.identity_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Identities List
struct IdentityList
{
    /// Total number of identities that matched your query.
    @jsonKey("total") long total;

    /// List of identities.
    @jsonKey("identities") models.Identity[] identities;

    /// Parse a `IdentityList` from JSON.
    static IdentityList fromJson(JSONValue json)
    {
        return deserialize!(IdentityList)(json);
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
