module appwrite.models.transaction;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Transaction
struct Transaction
{
    /// Transaction ID.
    @jsonKey("$id") string id;

    /// Transaction creation time in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Transaction update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// Current status of the transaction. One of: pending, committing, committed,
    /// rolled_back, failed.
    @jsonKey("status") string status = "pending";

    /// Number of operations in the transaction.
    @jsonKey("operations") long operations;

    /// Expiration time in ISO 8601 format.
    @jsonKey("expiresAt") string expiresAt;

    /// Parse a `Transaction` from JSON.
    static Transaction fromJson(JSONValue json)
    {
        return deserialize!(Transaction)(json);
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
