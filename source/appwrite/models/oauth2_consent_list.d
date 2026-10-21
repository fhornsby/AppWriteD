module appwrite.models.oauth2_consent_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 consents list
struct Oauth2ConsentList
{
    /// Total number of consents that matched your query.
    @jsonKey("total") long total;

    /// List of consents.
    @jsonKey("consents") models.Oauth2Consent[] consents;

    /// Parse a `Oauth2ConsentList` from JSON.
    static Oauth2ConsentList fromJson(JSONValue json)
    {
        return deserialize!(Oauth2ConsentList)(json);
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
