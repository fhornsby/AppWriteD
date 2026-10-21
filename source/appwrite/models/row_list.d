module appwrite.models.row_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Rows List
struct RowList
{
    /// Total number of rows that matched your query.
    @jsonKey("total") long total;

    /// List of rows.
    @jsonKey("rows") models.Row[] rows;

    /// Parse a `RowList` from JSON.
    static RowList fromJson(JSONValue json)
    {
        return deserialize!(RowList)(json);
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
