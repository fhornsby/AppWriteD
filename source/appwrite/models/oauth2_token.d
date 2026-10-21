module appwrite.models.oauth2_token;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 Token
struct Oauth2Token
{
    /// OAuth2 access token.
    @jsonKey("access_token") string accessToken;

    /// OAuth2 token type.
    @jsonKey("token_type") string tokenType = "Bearer";

    /// Access token lifetime in seconds.
    @jsonKey("expires_in") long expiresIn;

    /// OAuth2 refresh token.
    @jsonKey("refresh_token") string refreshToken;

    /// Space-separated scopes granted to the access token.
    @jsonKey("scope") string scope_;

    /// Granted RFC 9396 authorization details as a JSON string.
    @jsonKey("authorization_details") string authorizationDetails;

    /// OpenID Connect ID token. Returned when the `openid` scope is granted.
    @jsonKey("id_token") string idToken;

    /// Parse a `Oauth2Token` from JSON.
    static Oauth2Token fromJson(JSONValue json)
    {
        return deserialize!(Oauth2Token)(json);
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
