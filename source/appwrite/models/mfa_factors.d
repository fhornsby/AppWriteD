module appwrite.models.mfa_factors;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// MFAFactors
struct MfaFactors
{
    /// Can TOTP be used for MFA challenge for this account.
    @jsonKey("totp") bool totp = false;

    /// Can phone (SMS) be used for MFA challenge for this account.
    @jsonKey("phone") bool phone = false;

    /// Can email be used for MFA challenge for this account.
    @jsonKey("email") bool email = false;

    /// Can recovery code be used for MFA challenge for this account.
    @jsonKey("recoveryCode") bool recoveryCode = false;

    /// Can custom factor be used for MFA challenge for this account.
    @jsonKey("custom") bool custom = false;

    /// Parse a `MfaFactors` from JSON.
    static MfaFactors fromJson(JSONValue json)
    {
        return deserialize!(MfaFactors)(json);
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
