module appwrite.models.document_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Documents List
struct DocumentList
{
    /// Total number of documents that matched your query.
    @jsonKey("total") long total;

    /// List of documents.
    @jsonKey("documents") models.Document[] documents;

    /// Parse a `DocumentList` from JSON.
    static DocumentList fromJson(JSONValue json)
    {
        return deserialize!(DocumentList)(json);
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
