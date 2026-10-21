module appwrite.models.oauth2_consent_token_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 consent tokens list
struct Oauth2ConsentTokenList
{
    /// Total number of tokens that matched your query.
    @jsonKey("total") long total;

    /// List of tokens.
    @jsonKey("tokens") models.Oauth2ConsentToken[] tokens;

    /// Parse a `Oauth2ConsentTokenList` from JSON.
    static Oauth2ConsentTokenList fromJson(JSONValue json)
    {
        return deserialize!(Oauth2ConsentTokenList)(json);
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
