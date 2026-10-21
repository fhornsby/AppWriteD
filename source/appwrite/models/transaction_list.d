module appwrite.models.transaction_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Transaction List
struct TransactionList
{
    /// Total number of transactions that matched your query.
    @jsonKey("total") long total;

    /// List of transactions.
    @jsonKey("transactions") models.Transaction[] transactions;

    /// Parse a `TransactionList` from JSON.
    static TransactionList fromJson(JSONValue json)
    {
        return deserialize!(TransactionList)(json);
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
