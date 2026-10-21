module appwrite.services.analytics;

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

class Analytics : Service
{
    this(Client client)
    {
        super(client);
    }

    /// Send a tracking event from a browser, native app, or server-side SDK.
    JSONValue createEvent(string propertyId, string name, string url, string domain = null, string referrer = null, long screenWidth = unset!long, string sessionHash = null, long scrollDepth = unset!long, long engagementTime = unset!long, string[] props = null, string userId = null, string ip = null, string userAgent = null)
    {
        if (propertyId.length == 0)
            throw new AppwriteException(`Missing required parameter: "propertyId"`);
        auto apiPath = "/analytics/properties/{propertyId}/events"
            .replace("{propertyId}", encodeComponent(propertyId));

        JSONValue[string] apiParams;
        apiParams["name"] = serialize(name);
        apiParams["url"] = serialize(url);
        if (domain !is null)
            apiParams["domain"] = serialize(domain);
        if (referrer !is null)
            apiParams["referrer"] = serialize(referrer);
        if (isSet(screenWidth))
            apiParams["screenWidth"] = serialize(screenWidth);
        if (sessionHash !is null)
            apiParams["sessionHash"] = serialize(sessionHash);
        if (isSet(scrollDepth))
            apiParams["scrollDepth"] = serialize(scrollDepth);
        if (isSet(engagementTime))
            apiParams["engagementTime"] = serialize(engagementTime);
        if (props !is null)
            apiParams["props"] = serialize(props);
        if (userId !is null)
            apiParams["userId"] = serialize(userId);
        if (ip !is null)
            apiParams["ip"] = serialize(ip);
        if (userAgent !is null)
            apiParams["userAgent"] = serialize(userAgent);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return apiResponse.json;
    }
}
