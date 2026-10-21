module appwrite.models.mfa_type;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// MFAType
struct MfaType
{
    /// Secret token used for TOTP factor.
    @jsonKey("secret") string secret;

    /// URI for authenticator apps.
    @jsonKey("uri") string uri;

    /// Parse a `MfaType` from JSON.
    static MfaType fromJson(JSONValue json)
    {
        return deserialize!(MfaType)(json);
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
