module appwrite.services.storage;

import std.array : replace;
import std.conv : to;
import std.json;
import std.typecons : Nullable;
import std.uri : encodeComponent;

import appwrite.client;
import appwrite.exception;
import appwrite.input_file;
import appwrite.json;
import appwrite.service;
import appwrite.upload_progress;
import enums = appwrite.enums;
import models = appwrite.models;

/// The Storage service allows you to manage your project files.
class Storage : Service
{
    this(Client client)
    {
        super(client);
    }

    /// Get a list of all the user files. You can use the query params to filter your
    /// results.
    models.FileList listFiles(string bucketId, string[] queries = null, string search = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        if (bucketId.length == 0)
            throw new AppwriteException(`Missing required parameter: "bucketId"`);
        auto apiPath = "/storage/buckets/{bucketId}/files"
            .replace("{bucketId}", encodeComponent(bucketId));

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (search !is null)
            apiParams["search"] = serialize(search);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.FileList)(apiResponse.json);
    }

    /// Create a new file. Before using this route, you should create a new bucket
    /// resource using either a [server
    /// integration](https://appwrite.io/docs/server/storage#storageCreateBucket) API or
    /// directly from your Appwrite console.
    ///
    /// Larger files should be uploaded using multiple requests with the
    /// [content-range](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Range)
    /// header to send a partial request with a maximum supported chunk of `5MB`. The
    /// `content-range` header values should always be in bytes.
    ///
    /// When the first request is sent, the server will return the **File** object, and
    /// the subsequent part request must include the file's **id** in `x-appwrite-id`
    /// header to allow the server to know that the partial upload is for the existing
    /// file and not for a new one.
    ///
    /// If you're creating a new file using one of the Appwrite SDKs, all the chunking
    /// logic will be managed by the SDK internally.
    models.File createFile(string bucketId, string fileId, InputFile file, string[] permissions = null, string folder = null, UploadProgressCallback onProgress = null)
    {
        if (bucketId.length == 0)
            throw new AppwriteException(`Missing required parameter: "bucketId"`);
        auto apiPath = "/storage/buckets/{bucketId}/files"
            .replace("{bucketId}", encodeComponent(bucketId));

        JSONValue[string] apiParams;
        apiParams["fileId"] = serialize(fileId);
        if (permissions !is null)
            apiParams["permissions"] = serialize(permissions);
        if (folder !is null)
            apiParams["folder"] = serialize(folder);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "multipart/form-data";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.chunkedUpload(HttpMethod.post, apiPath, apiHeaders, apiParams,
            "file", "fileId", file, onProgress);
        return deserialize!(models.File)(apiResponse.json);
    }

    /// Get a file by its unique ID. This endpoint response returns a JSON object with
    /// the file metadata.
    models.File getFile(string bucketId, string fileId)
    {
        if (bucketId.length == 0)
            throw new AppwriteException(`Missing required parameter: "bucketId"`);
        if (fileId.length == 0)
            throw new AppwriteException(`Missing required parameter: "fileId"`);
        auto apiPath = "/storage/buckets/{bucketId}/files/{fileId}"
            .replace("{bucketId}", encodeComponent(bucketId))
            .replace("{fileId}", encodeComponent(fileId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.File)(apiResponse.json);
    }

    /// Update a file by its unique ID. Only users with write permissions have access to
    /// update this resource.
    models.File updateFile(string bucketId, string fileId, string name = null, string[] permissions = null)
    {
        if (bucketId.length == 0)
            throw new AppwriteException(`Missing required parameter: "bucketId"`);
        if (fileId.length == 0)
            throw new AppwriteException(`Missing required parameter: "fileId"`);
        auto apiPath = "/storage/buckets/{bucketId}/files/{fileId}"
            .replace("{bucketId}", encodeComponent(bucketId))
            .replace("{fileId}", encodeComponent(fileId));

        JSONValue[string] apiParams;
        if (name !is null)
            apiParams["name"] = serialize(name);
        if (permissions !is null)
            apiParams["permissions"] = serialize(permissions);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.File)(apiResponse.json);
    }

    /// Delete a file by its unique ID. Only users with write permissions have access to
    /// delete this resource.
    void deleteFile(string bucketId, string fileId)
    {
        if (bucketId.length == 0)
            throw new AppwriteException(`Missing required parameter: "bucketId"`);
        if (fileId.length == 0)
            throw new AppwriteException(`Missing required parameter: "fileId"`);
        auto apiPath = "/storage/buckets/{bucketId}/files/{fileId}"
            .replace("{bucketId}", encodeComponent(bucketId))
            .replace("{fileId}", encodeComponent(fileId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Get a file content by its unique ID. The endpoint response return with a
    /// 'Content-Disposition: attachment' header that tells the browser to start
    /// downloading the file to user downloads directory.
    ubyte[] getFileDownload(string bucketId, string fileId, string token = null)
    {
        if (bucketId.length == 0)
            throw new AppwriteException(`Missing required parameter: "bucketId"`);
        if (fileId.length == 0)
            throw new AppwriteException(`Missing required parameter: "fileId"`);
        auto apiPath = "/storage/buckets/{bucketId}/files/{fileId}/download"
            .replace("{bucketId}", encodeComponent(bucketId))
            .replace("{fileId}", encodeComponent(fileId));

        JSONValue[string] apiParams;
        if (token !is null)
            apiParams["token"] = serialize(token);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "*/*";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams, ResponseType.bytes);
        return apiResponse.bytes;
    }

    /// Get a file preview image. Currently, this method supports preview for image
    /// files (jpg, png, and gif), other supported formats, like pdf, docs, slides, and
    /// spreadsheets, will return the file icon image. You can also pass query string
    /// arguments for cutting and resizing your preview image. Preview is supported only
    /// for image files smaller than 10MB.
    ubyte[] getFilePreview(string bucketId, string fileId, long width = unset!long, long height = unset!long, enums.ImageGravity gravity = cast(enums.ImageGravity) null, long quality = unset!long, long borderWidth = unset!long, string borderColor = null, long borderRadius = unset!long, double opacity = unset!double, long rotation = unset!long, string background = null, enums.ImageFormat output = cast(enums.ImageFormat) null, string token = null)
    {
        if (bucketId.length == 0)
            throw new AppwriteException(`Missing required parameter: "bucketId"`);
        if (fileId.length == 0)
            throw new AppwriteException(`Missing required parameter: "fileId"`);
        auto apiPath = "/storage/buckets/{bucketId}/files/{fileId}/preview"
            .replace("{bucketId}", encodeComponent(bucketId))
            .replace("{fileId}", encodeComponent(fileId));

        JSONValue[string] apiParams;
        if (isSet(width))
            apiParams["width"] = serialize(width);
        if (isSet(height))
            apiParams["height"] = serialize(height);
        if (gravity !is null)
            apiParams["gravity"] = serialize(gravity);
        if (isSet(quality))
            apiParams["quality"] = serialize(quality);
        if (isSet(borderWidth))
            apiParams["borderWidth"] = serialize(borderWidth);
        if (borderColor !is null)
            apiParams["borderColor"] = serialize(borderColor);
        if (isSet(borderRadius))
            apiParams["borderRadius"] = serialize(borderRadius);
        if (isSet(opacity))
            apiParams["opacity"] = serialize(opacity);
        if (isSet(rotation))
            apiParams["rotation"] = serialize(rotation);
        if (background !is null)
            apiParams["background"] = serialize(background);
        if (output !is null)
            apiParams["output"] = serialize(output);
        if (token !is null)
            apiParams["token"] = serialize(token);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "image/*";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams, ResponseType.bytes);
        return apiResponse.bytes;
    }

    /// Get a file content by its unique ID. This endpoint is similar to the download
    /// method but returns with no  'Content-Disposition: attachment' header.
    ubyte[] getFileView(string bucketId, string fileId, string token = null)
    {
        if (bucketId.length == 0)
            throw new AppwriteException(`Missing required parameter: "bucketId"`);
        if (fileId.length == 0)
            throw new AppwriteException(`Missing required parameter: "fileId"`);
        auto apiPath = "/storage/buckets/{bucketId}/files/{fileId}/view"
            .replace("{bucketId}", encodeComponent(bucketId))
            .replace("{fileId}", encodeComponent(fileId));

        JSONValue[string] apiParams;
        if (token !is null)
            apiParams["token"] = serialize(token);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "*/*";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams, ResponseType.bytes);
        return apiResponse.bytes;
    }
}
