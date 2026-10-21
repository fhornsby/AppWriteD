module appwrite.models.oauth2_approve;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 Approve
struct Oauth2Approve
{
    /// URL the end user should be redirected to after the grant is approved, carrying
    /// the authorization `code` and/or `id_token` along with the original `state`.
    @jsonKey("redirectUrl") string redirectUrl;

    /// Parse a `Oauth2Approve` from JSON.
    static Oauth2Approve fromJson(JSONValue json)
    {
        return deserialize!(Oauth2Approve)(json);
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
