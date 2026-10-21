module appwrite.models.file_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Files List
struct FileList
{
    /// Total number of files that matched your query.
    @jsonKey("total") long total;

    /// List of files.
    @jsonKey("files") models.File[] files;

    /// Parse a `FileList` from JSON.
    static FileList fromJson(JSONValue json)
    {
        return deserialize!(FileList)(json);
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
