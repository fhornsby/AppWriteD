module appwrite.models.currency;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Currency
struct Currency
{
    /// Currency symbol.
    @jsonKey("symbol") string symbol;

    /// Currency name.
    @jsonKey("name") string name;

    /// Currency native symbol.
    @jsonKey("symbolNative") string symbolNative;

    /// Number of decimal digits.
    @jsonKey("decimalDigits") long decimalDigits;

    /// Currency digit rounding.
    @jsonKey("rounding") double rounding = 0.0;

    /// Currency code in [ISO 4217-1](http://en.wikipedia.org/wiki/ISO_4217)
    /// three-character format.
    @jsonKey("code") string code;

    /// Currency plural name
    @jsonKey("namePlural") string namePlural;

    /// Parse a `Currency` from JSON.
    static Currency fromJson(JSONValue json)
    {
        return deserialize!(Currency)(json);
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
