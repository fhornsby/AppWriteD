module appwrite.models.execution;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Execution
struct Execution
{
    /// Execution ID.
    @jsonKey("$id") string id;

    /// Execution creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Execution update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// Execution roles.
    @jsonKey("$permissions") string[] permissions;

    /// Function or site ID.
    @jsonKey("resourceId") string resourceId;

    /// Execution resource type.
    @jsonKey("resourceType") enums.ExecutionResourceType resourceType = cast(enums.ExecutionResourceType) "functions";

    /// Deployment ID used to create the execution.
    @jsonKey("deploymentId") string deploymentId;

    /// The trigger that caused the resource to execute. Possible values can be: `http`,
    /// `schedule`, or `event`.
    @jsonKey("trigger") enums.ExecutionTrigger trigger;

    /// The status of the resource execution. Possible values can be: `waiting`,
    /// `processing`, `completed`, `failed`, or `scheduled`.
    @jsonKey("status") enums.ExecutionStatus status;

    /// HTTP request method type.
    @jsonKey("requestMethod") string requestMethod;

    /// HTTP request path and query.
    @jsonKey("requestPath") string requestPath;

    /// HTTP request headers as a key-value object. This will return only whitelisted
    /// headers. All headers are returned if execution is created as synchronous.
    @jsonKey("requestHeaders") models.Headers[] requestHeaders;

    /// HTTP response status code.
    @jsonKey("responseStatusCode") long responseStatusCode;

    /// HTTP response body. This will return empty unless execution is created as
    /// synchronous.
    @jsonKey("responseBody") string responseBody;

    /// HTTP response headers as a key-value object. This will return only whitelisted
    /// headers. All headers are returned if execution is created as synchronous.
    @jsonKey("responseHeaders") models.Headers[] responseHeaders;

    /// Resource logs. Includes the last 4,000 characters. This will return an empty
    /// string unless the response is returned using an API key or as part of a webhook
    /// payload.
    @jsonKey("logs") string logs;

    /// Resource errors. Includes the last 4,000 characters. This will return an empty
    /// string unless the response is returned using an API key or as part of a webhook
    /// payload.
    @jsonKey("errors") string errors;

    /// Total time the resource(function/site) took to respond, in seconds.
    @jsonKey("duration") double duration = 0.0;

    /// The scheduled time for execution. If left empty, execution will be queued
    /// immediately.
    @jsonKey("scheduledAt") string scheduledAt;

    /// Parse a `Execution` from JSON.
    static Execution fromJson(JSONValue json)
    {
        return deserialize!(Execution)(json);
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
