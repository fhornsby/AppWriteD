module appwrite.models.oauth2_reject;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 Reject
struct Oauth2Reject
{
    /// URL the end user should be redirected to after the grant is rejected, carrying
    /// an `access_denied` error.
    @jsonKey("redirectUrl") string redirectUrl;

    /// Parse a `Oauth2Reject` from JSON.
    static Oauth2Reject fromJson(JSONValue json)
    {
        return deserialize!(Oauth2Reject)(json);
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
