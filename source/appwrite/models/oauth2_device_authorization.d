module appwrite.models.oauth2_device_authorization;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 Device Authorization
struct Oauth2DeviceAuthorization
{
    /// Device verification code used by the client to poll the token endpoint.
    @jsonKey("device_code") string deviceCode;

    /// Short code the end user enters on the verification page.
    @jsonKey("user_code") string userCode;

    /// URL where the end user enters the user code.
    @jsonKey("verification_uri") string verificationUri;

    /// Verification URL with the user code prefilled as a query parameter.
    @jsonKey("verification_uri_complete") string verificationUriComplete;

    /// Lifetime of the device code and user code in seconds.
    @jsonKey("expires_in") long expiresIn;

    /// Minimum polling interval for the token endpoint in seconds.
    @jsonKey("interval") long interval;

    /// Parse a `Oauth2DeviceAuthorization` from JSON.
    static Oauth2DeviceAuthorization fromJson(JSONValue json)
    {
        return deserialize!(Oauth2DeviceAuthorization)(json);
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
