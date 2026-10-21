module appwrite.models.token_secret;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Token Secret
struct TokenSecret
{
    /// Token ID.
    @jsonKey("$id") string id;

    /// Token creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// User ID.
    @jsonKey("userId") string userId;

    /// Token secret key. Exchange it for a session with the create session endpoint.
    @jsonKey("secret") string secret;

    /// Token expiration date in ISO 8601 format.
    @jsonKey("expire") string expire;

    /// Security phrase of a token. Empty if security phrase was not requested when
    /// creating a token. It includes randomly generated phrase which is also sent in
    /// the external resource such as email.
    @jsonKey("phrase") string phrase;

    /// Parse a `TokenSecret` from JSON.
    static TokenSecret fromJson(JSONValue json)
    {
        return deserialize!(TokenSecret)(json);
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
