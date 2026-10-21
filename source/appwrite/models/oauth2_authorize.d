module appwrite.models.oauth2_authorize;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 Authorize
struct Oauth2Authorize
{
    /// OAuth2 grant ID. Set when the user must give explicit consent; pass it to the
    /// approve or reject endpoint. Empty when a redirect URL is returned instead.
    @jsonKey("grantId") string grantId;

    /// URL the end user should be redirected to when the flow can complete without
    /// consent. Empty when consent is still required.
    @jsonKey("redirectUrl") string redirectUrl;

    /// Parse a `Oauth2Authorize` from JSON.
    static Oauth2Authorize fromJson(JSONValue json)
    {
        return deserialize!(Oauth2Authorize)(json);
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
