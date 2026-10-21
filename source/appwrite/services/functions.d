module appwrite.services.functions;

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

/// The Functions Service allows you view, create and manage your Cloud Functions.
class Functions : Service
{
    this(Client client)
    {
        super(client);
    }

    /// Get a list of all the current user function execution logs. You can use the
    /// query params to filter your results.
    models.ExecutionList listExecutions(string functionId, string[] queries = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        if (functionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "functionId"`);
        auto apiPath = "/functions/{functionId}/executions"
            .replace("{functionId}", encodeComponent(functionId));

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.ExecutionList)(apiResponse.json);
    }

    /// Trigger a function execution. The returned object will return you the current
    /// execution status. You can ping the `Get Execution` endpoint to get updates on
    /// the current execution status. Once this endpoint is called, your function
    /// execution process will start asynchronously.
    models.Execution createExecution(string functionId, string body_ = null, Nullable!(bool) async = Nullable!(bool).init, string path = null, enums.ExecutionMethod method = cast(enums.ExecutionMethod) null, JSONValue headers = JSONValue.init, string scheduledAt = null)
    {
        if (functionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "functionId"`);
        auto apiPath = "/functions/{functionId}/executions"
            .replace("{functionId}", encodeComponent(functionId));

        JSONValue[string] apiParams;
        if (body_ !is null)
            apiParams["body"] = serialize(body_);
        if (!async.isNull)
            apiParams["async"] = serialize(async);
        if (path !is null)
            apiParams["path"] = serialize(path);
        if (method !is null)
            apiParams["method"] = serialize(method);
        if (headers.type != JSONType.null_)
            apiParams["headers"] = serialize(headers);
        if (scheduledAt !is null)
            apiParams["scheduledAt"] = serialize(scheduledAt);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Execution)(apiResponse.json);
    }

    /// Get a function execution log by its unique ID.
    models.Execution getExecution(string functionId, string executionId)
    {
        if (functionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "functionId"`);
        if (executionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "executionId"`);
        auto apiPath = "/functions/{functionId}/executions/{executionId}"
            .replace("{functionId}", encodeComponent(functionId))
            .replace("{executionId}", encodeComponent(executionId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Execution)(apiResponse.json);
    }
}
