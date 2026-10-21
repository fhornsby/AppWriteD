module appwrite.services.messaging;

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

/// The Messaging service allows you to send messages to any provider type (SMTP,
/// push notification, SMS, etc.).
class Messaging : Service
{
    this(Client client)
    {
        super(client);
    }

    /// Create a new subscriber.
    models.Subscriber createSubscriber(string topicId, string subscriberId, string targetId)
    {
        if (topicId.length == 0)
            throw new AppwriteException(`Missing required parameter: "topicId"`);
        auto apiPath = "/messaging/topics/{topicId}/subscribers"
            .replace("{topicId}", encodeComponent(topicId));

        JSONValue[string] apiParams;
        apiParams["subscriberId"] = serialize(subscriberId);
        apiParams["targetId"] = serialize(targetId);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Subscriber)(apiResponse.json);
    }

    /// Delete a subscriber by its unique ID.
    void deleteSubscriber(string topicId, string subscriberId)
    {
        if (topicId.length == 0)
            throw new AppwriteException(`Missing required parameter: "topicId"`);
        if (subscriberId.length == 0)
            throw new AppwriteException(`Missing required parameter: "subscriberId"`);
        auto apiPath = "/messaging/topics/{topicId}/subscribers/{subscriberId}"
            .replace("{topicId}", encodeComponent(topicId))
            .replace("{subscriberId}", encodeComponent(subscriberId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }
}
