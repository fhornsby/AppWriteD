module appwrite.models.file;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// File
struct File
{
    /// File ID.
    @jsonKey("$id") string id;

    /// Bucket ID.
    @jsonKey("bucketId") string bucketId;

    /// File creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// File update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// File permissions. [Learn more about
    /// permissions](https://appwrite.io/docs/permissions).
    @jsonKey("$permissions") string[] permissions;

    /// File name.
    @jsonKey("name") string name;

    /// Virtual folder containing the file, with a trailing slash. Empty for the bucket
    /// root.
    @jsonKey("folder") string folder;

    /// Full virtual path of the file: the folder followed by the file name.
    @jsonKey("key") string key;

    /// File MD5 signature.
    @jsonKey("signature") string signature;

    /// File mime type.
    @jsonKey("mimeType") string mimeType;

    /// File original size in bytes.
    @jsonKey("sizeOriginal") long sizeOriginal;

    /// File actual stored size in bytes after compression and/or encryption.
    @jsonKey("sizeActual") long sizeActual;

    /// Total number of chunks available
    @jsonKey("chunksTotal") long chunksTotal;

    /// Total number of chunks uploaded
    @jsonKey("chunksUploaded") long chunksUploaded;

    /// Whether file contents are encrypted at rest.
    @jsonKey("encryption") bool encryption = false;

    /// Compression algorithm used for the file. Will be one of none,
    /// [gzip](https://en.wikipedia.org/wiki/Gzip), or
    /// [zstd](https://en.wikipedia.org/wiki/Zstd).
    @jsonKey("compression") string compression = "none";

    /// Parse a `File` from JSON.
    static File fromJson(JSONValue json)
    {
        return deserialize!(File)(json);
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
