module appwrite.services.graphql;

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

/// The GraphQL API allows you to query and mutate your Appwrite server using
/// GraphQL.
class Graphql : Service
{
    this(Client client)
    {
        super(client);
    }

    /// Execute a GraphQL mutation.
    JSONValue query(JSONValue query)
    {
        auto apiPath = "/graphql";

        JSONValue[string] apiParams;
        apiParams["query"] = serialize(query);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["x-sdk-graphql"] = "true";
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return apiResponse.json;
    }

    /// Execute a GraphQL mutation.
    JSONValue mutation(JSONValue query)
    {
        auto apiPath = "/graphql/mutation";

        JSONValue[string] apiParams;
        apiParams["query"] = serialize(query);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["x-sdk-graphql"] = "true";
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return apiResponse.json;
    }
}
