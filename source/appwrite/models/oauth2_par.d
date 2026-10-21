module appwrite.models.oauth2_par;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 PAR
struct Oauth2PAR
{
    /// Authorization request handle to pass to the authorize endpoint.
    @jsonKey("request_uri") string requestUri;

    /// Lifetime of the authorization request handle in seconds.
    @jsonKey("expires_in") long expiresIn;

    /// Parse a `Oauth2PAR` from JSON.
    static Oauth2PAR fromJson(JSONValue json)
    {
        return deserialize!(Oauth2PAR)(json);
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
