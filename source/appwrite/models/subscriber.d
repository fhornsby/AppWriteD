module appwrite.models.subscriber;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Subscriber
struct Subscriber
{
    /// Subscriber ID.
    @jsonKey("$id") string id;

    /// Subscriber creation time in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Subscriber update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// Target ID.
    @jsonKey("targetId") string targetId;

    /// Target.
    @jsonKey("target") models.Target target;

    /// Topic ID.
    @jsonKey("userId") string userId;

    /// User Name.
    @jsonKey("userName") string userName;

    /// Topic ID.
    @jsonKey("topicId") string topicId;

    /// The target provider type. Can be one of the following: `email`, `sms` or `push`.
    @jsonKey("providerType") string providerType;

    /// Parse a `Subscriber` from JSON.
    static Subscriber fromJson(JSONValue json)
    {
        return deserialize!(Subscriber)(json);
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
