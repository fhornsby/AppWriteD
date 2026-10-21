module appwrite.models.passkey_challenge;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Passkey Challenge
struct PasskeyChallenge
{
    /// Challenge ID. When signing in, pass it back with the credential to receive a
    /// token.
    @jsonKey("$id") string id;

    /// Challenge creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// ID of the passkey being registered. Empty for sign-in challenges.
    @jsonKey("passkeyId") string passkeyId;

    /// Challenge expiration date in ISO 8601 format.
    @jsonKey("expire") string expire;

    /// WebAuthn options in JSON form. Pass them to
    /// `PublicKeyCredential.parseCreationOptionsFromJSON()` when registering, or
    /// `PublicKeyCredential.parseRequestOptionsFromJSON()` when signing in.
    @jsonKey("publicKey") JSONValue publicKey;

    /// Parse a `PasskeyChallenge` from JSON.
    static PasskeyChallenge fromJson(JSONValue json)
    {
        return deserialize!(PasskeyChallenge)(json);
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
