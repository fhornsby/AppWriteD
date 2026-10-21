module appwrite.models.mfa_recovery_codes;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// MFA Recovery Codes
struct MfaRecoveryCodes
{
    /// Recovery codes.
    @jsonKey("recoveryCodes") string[] recoveryCodes;

    /// Parse a `MfaRecoveryCodes` from JSON.
    static MfaRecoveryCodes fromJson(JSONValue json)
    {
        return deserialize!(MfaRecoveryCodes)(json);
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
