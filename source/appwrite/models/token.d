module appwrite.models.token;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Token
struct Token
{
    /// Token ID.
    @jsonKey("$id") string id;

    /// Token creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// User ID.
    @jsonKey("userId") string userId;

    /// Token secret key. This will return an empty string unless the response is
    /// returned using an API key or as part of a webhook payload.
    @jsonKey("secret") string secret;

    /// Token expiration date in ISO 8601 format.
    @jsonKey("expire") string expire;

    /// Security phrase of a token. Empty if security phrase was not requested when
    /// creating a token. It includes randomly generated phrase which is also sent in
    /// the external resource such as email.
    @jsonKey("phrase") string phrase;

    /// Parse a `Token` from JSON.
    static Token fromJson(JSONValue json)
    {
        return deserialize!(Token)(json);
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
