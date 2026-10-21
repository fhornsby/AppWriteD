module appwrite.models.currency_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Currencies List
struct CurrencyList
{
    /// Total number of currencies that matched your query.
    @jsonKey("total") long total;

    /// List of currencies.
    @jsonKey("currencies") models.Currency[] currencies;

    /// Parse a `CurrencyList` from JSON.
    static CurrencyList fromJson(JSONValue json)
    {
        return deserialize!(CurrencyList)(json);
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
