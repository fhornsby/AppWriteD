module appwrite.services.presences;

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

/// The Presences service allows you to track and manage real-time user presence in
/// your project.
class Presences : Service
{
    this(Client client)
    {
        super(client);
    }

    /// List presence logs. Expired entries are filtered out automatically.
    models.PresenceList list(string[] queries = null, Nullable!(bool) total = Nullable!(bool).init, long ttl = unset!long)
    {
        auto apiPath = "/presences";

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (!total.isNull)
            apiParams["total"] = serialize(total);
        if (isSet(ttl))
            apiParams["ttl"] = serialize(ttl);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.PresenceList)(apiResponse.json);
    }

    /// Get a presence log by its unique ID. Entries whose `expiresAt` is in the past
    /// are treated as not found.
    models.Presence get(string presenceId)
    {
        if (presenceId.length == 0)
            throw new AppwriteException(`Missing required parameter: "presenceId"`);
        auto apiPath = "/presences/{presenceId}"
            .replace("{presenceId}", encodeComponent(presenceId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Presence)(apiResponse.json);
    }

    /// Create or update a presence log by its user ID.
    models.Presence upsert(string presenceId, string status, string[] permissions = null, string expiresAt = null, JSONValue metadata = JSONValue.init)
    {
        if (presenceId.length == 0)
            throw new AppwriteException(`Missing required parameter: "presenceId"`);
        auto apiPath = "/presences/{presenceId}"
            .replace("{presenceId}", encodeComponent(presenceId));

        JSONValue[string] apiParams;
        apiParams["status"] = serialize(status);
        if (permissions !is null)
            apiParams["permissions"] = serialize(permissions);
        if (expiresAt !is null)
            apiParams["expiresAt"] = serialize(expiresAt);
        if (metadata.type != JSONType.null_)
            apiParams["metadata"] = serialize(metadata);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Presence)(apiResponse.json);
    }

    /// Update a presence log by its unique ID. Using the patch method you can pass only
    /// specific fields that will get updated.
    models.Presence update(string presenceId, string status = null, string expiresAt = null, JSONValue metadata = JSONValue.init, string[] permissions = null, Nullable!(bool) purge = Nullable!(bool).init)
    {
        if (presenceId.length == 0)
            throw new AppwriteException(`Missing required parameter: "presenceId"`);
        auto apiPath = "/presences/{presenceId}"
            .replace("{presenceId}", encodeComponent(presenceId));

        JSONValue[string] apiParams;
        if (status !is null)
            apiParams["status"] = serialize(status);
        if (expiresAt !is null)
            apiParams["expiresAt"] = serialize(expiresAt);
        if (metadata.type != JSONType.null_)
            apiParams["metadata"] = serialize(metadata);
        if (permissions !is null)
            apiParams["permissions"] = serialize(permissions);
        if (!purge.isNull)
            apiParams["purge"] = serialize(purge);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Presence)(apiResponse.json);
    }

    /// Delete a presence log by its unique ID.
    void delete_(string presenceId)
    {
        if (presenceId.length == 0)
            throw new AppwriteException(`Missing required parameter: "presenceId"`);
        auto apiPath = "/presences/{presenceId}"
            .replace("{presenceId}", encodeComponent(presenceId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }
}
