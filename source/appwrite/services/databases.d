module appwrite.services.databases;

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

/// The Databases service allows you to create structured collections of documents,
/// query and filter lists of documents
class Databases : Service
{
    this(Client client)
    {
        super(client);
    }

    /// List transactions across all databases.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.listTransactions` instead.")
    models.TransactionList listTransactions(string[] queries = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/databases/transactions";

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.TransactionList)(apiResponse.json);
    }

    /// Create a new transaction.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.createTransaction` instead.")
    models.Transaction createTransaction(long ttl = unset!long)
    {
        auto apiPath = "/databases/transactions";

        JSONValue[string] apiParams;
        if (isSet(ttl))
            apiParams["ttl"] = serialize(ttl);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Transaction)(apiResponse.json);
    }

    /// Get a transaction by its unique ID.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.getTransaction` instead.")
    models.Transaction getTransaction(string transactionId)
    {
        if (transactionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "transactionId"`);
        auto apiPath = "/databases/transactions/{transactionId}"
            .replace("{transactionId}", encodeComponent(transactionId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Transaction)(apiResponse.json);
    }

    /// Update a transaction, to either commit or roll back its operations.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.updateTransaction` instead.")
    models.Transaction updateTransaction(string transactionId, Nullable!(bool) commit = Nullable!(bool).init, Nullable!(bool) rollback = Nullable!(bool).init)
    {
        if (transactionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "transactionId"`);
        auto apiPath = "/databases/transactions/{transactionId}"
            .replace("{transactionId}", encodeComponent(transactionId));

        JSONValue[string] apiParams;
        if (!commit.isNull)
            apiParams["commit"] = serialize(commit);
        if (!rollback.isNull)
            apiParams["rollback"] = serialize(rollback);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Transaction)(apiResponse.json);
    }

    /// Delete a transaction by its unique ID.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.deleteTransaction` instead.")
    void deleteTransaction(string transactionId)
    {
        if (transactionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "transactionId"`);
        auto apiPath = "/databases/transactions/{transactionId}"
            .replace("{transactionId}", encodeComponent(transactionId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Create multiple operations in a single transaction.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.createOperations` instead.")
    models.Transaction createOperations(string transactionId, JSONValue[] operations = null)
    {
        if (transactionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "transactionId"`);
        auto apiPath = "/databases/transactions/{transactionId}/operations"
            .replace("{transactionId}", encodeComponent(transactionId));

        JSONValue[string] apiParams;
        if (operations !is null)
            apiParams["operations"] = serialize(operations);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Transaction)(apiResponse.json);
    }

    /// Get a list of all the user's documents in a given collection. You can use the
    /// query params to filter your results.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.listRows` instead.")
    models.DocumentList listDocuments(string databaseId, string collectionId, string[] queries = null, string transactionId = null, Nullable!(bool) total = Nullable!(bool).init, long ttl = unset!long)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (collectionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "collectionId"`);
        auto apiPath = "/databases/{databaseId}/collections/{collectionId}/documents"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{collectionId}", encodeComponent(collectionId));

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (transactionId !is null)
            apiParams["transactionId"] = serialize(transactionId);
        if (!total.isNull)
            apiParams["total"] = serialize(total);
        if (isSet(ttl))
            apiParams["ttl"] = serialize(ttl);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.DocumentList)(apiResponse.json);
    }

    /// Create a new Document. Before using this route, you should create a new
    /// collection resource using either a [server
    /// integration](https://appwrite.io/docs/server/databases#databasesCreateCollection)
    /// API or directly from your database console.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.createRow` instead.")
    models.Document createDocument(string databaseId, string collectionId, string documentId, JSONValue data, string[] permissions = null, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (collectionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "collectionId"`);
        auto apiPath = "/databases/{databaseId}/collections/{collectionId}/documents"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{collectionId}", encodeComponent(collectionId));

        JSONValue[string] apiParams;
        apiParams["documentId"] = serialize(documentId);
        apiParams["data"] = serialize(data);
        if (permissions !is null)
            apiParams["permissions"] = serialize(permissions);
        if (transactionId !is null)
            apiParams["transactionId"] = serialize(transactionId);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Document)(apiResponse.json);
    }

    /// Get a document by its unique ID. This endpoint response returns a JSON object
    /// with the document data.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.getRow` instead.")
    models.Document getDocument(string databaseId, string collectionId, string documentId, string[] queries = null, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (collectionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "collectionId"`);
        if (documentId.length == 0)
            throw new AppwriteException(`Missing required parameter: "documentId"`);
        auto apiPath = "/databases/{databaseId}/collections/{collectionId}/documents/{documentId}"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{collectionId}", encodeComponent(collectionId))
            .replace("{documentId}", encodeComponent(documentId));

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (transactionId !is null)
            apiParams["transactionId"] = serialize(transactionId);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Document)(apiResponse.json);
    }

    /// Create or update a Document. Before using this route, you should create a new
    /// collection resource using either a [server
    /// integration](https://appwrite.io/docs/server/databases#databasesCreateCollection)
    /// API or directly from your database console.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.upsertRow` instead.")
    models.Document upsertDocument(string databaseId, string collectionId, string documentId, JSONValue data = JSONValue.init, string[] permissions = null, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (collectionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "collectionId"`);
        if (documentId.length == 0)
            throw new AppwriteException(`Missing required parameter: "documentId"`);
        auto apiPath = "/databases/{databaseId}/collections/{collectionId}/documents/{documentId}"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{collectionId}", encodeComponent(collectionId))
            .replace("{documentId}", encodeComponent(documentId));

        JSONValue[string] apiParams;
        if (data.type != JSONType.null_)
            apiParams["data"] = serialize(data);
        if (permissions !is null)
            apiParams["permissions"] = serialize(permissions);
        if (transactionId !is null)
            apiParams["transactionId"] = serialize(transactionId);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Document)(apiResponse.json);
    }

    /// Update a document by its unique ID. Using the patch method you can pass only
    /// specific fields that will get updated.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.updateRow` instead.")
    models.Document updateDocument(string databaseId, string collectionId, string documentId, JSONValue data = JSONValue.init, string[] permissions = null, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (collectionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "collectionId"`);
        if (documentId.length == 0)
            throw new AppwriteException(`Missing required parameter: "documentId"`);
        auto apiPath = "/databases/{databaseId}/collections/{collectionId}/documents/{documentId}"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{collectionId}", encodeComponent(collectionId))
            .replace("{documentId}", encodeComponent(documentId));

        JSONValue[string] apiParams;
        if (data.type != JSONType.null_)
            apiParams["data"] = serialize(data);
        if (permissions !is null)
            apiParams["permissions"] = serialize(permissions);
        if (transactionId !is null)
            apiParams["transactionId"] = serialize(transactionId);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Document)(apiResponse.json);
    }

    /// Delete a document by its unique ID.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.deleteRow` instead.")
    void deleteDocument(string databaseId, string collectionId, string documentId, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (collectionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "collectionId"`);
        if (documentId.length == 0)
            throw new AppwriteException(`Missing required parameter: "documentId"`);
        auto apiPath = "/databases/{databaseId}/collections/{collectionId}/documents/{documentId}"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{collectionId}", encodeComponent(collectionId))
            .replace("{documentId}", encodeComponent(documentId));

        JSONValue[string] apiParams;
        if (transactionId !is null)
            apiParams["transactionId"] = serialize(transactionId);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Decrement a specific attribute of a document by a given value.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.decrementRowColumn` instead.")
    models.Document decrementDocumentAttribute(string databaseId, string collectionId, string documentId, string attribute, double value = unset!double, double min = unset!double, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (collectionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "collectionId"`);
        if (documentId.length == 0)
            throw new AppwriteException(`Missing required parameter: "documentId"`);
        if (attribute.length == 0)
            throw new AppwriteException(`Missing required parameter: "attribute"`);
        auto apiPath = "/databases/{databaseId}/collections/{collectionId}/documents/{documentId}/{attribute}/decrement"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{collectionId}", encodeComponent(collectionId))
            .replace("{documentId}", encodeComponent(documentId))
            .replace("{attribute}", encodeComponent(attribute));

        JSONValue[string] apiParams;
        if (isSet(value))
            apiParams["value"] = serialize(value);
        if (isSet(min))
            apiParams["min"] = serialize(min);
        if (transactionId !is null)
            apiParams["transactionId"] = serialize(transactionId);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Document)(apiResponse.json);
    }

    /// Increment a specific attribute of a document by a given value.
    deprecated("This API has been deprecated since 1.8.0. Please use `tablesDB.incrementRowColumn` instead.")
    models.Document incrementDocumentAttribute(string databaseId, string collectionId, string documentId, string attribute, double value = unset!double, double max = unset!double, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (collectionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "collectionId"`);
        if (documentId.length == 0)
            throw new AppwriteException(`Missing required parameter: "documentId"`);
        if (attribute.length == 0)
            throw new AppwriteException(`Missing required parameter: "attribute"`);
        auto apiPath = "/databases/{databaseId}/collections/{collectionId}/documents/{documentId}/{attribute}/increment"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{collectionId}", encodeComponent(collectionId))
            .replace("{documentId}", encodeComponent(documentId))
            .replace("{attribute}", encodeComponent(attribute));

        JSONValue[string] apiParams;
        if (isSet(value))
            apiParams["value"] = serialize(value);
        if (isSet(max))
            apiParams["max"] = serialize(max);
        if (transactionId !is null)
            apiParams["transactionId"] = serialize(transactionId);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Document)(apiResponse.json);
    }
}
