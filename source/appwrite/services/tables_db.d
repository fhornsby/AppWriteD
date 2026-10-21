module appwrite.services.tables_db;

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

/// The TablesDB service allows you to create structured tables of columns, query
/// and filter lists of rows
class TablesDB : Service
{
    this(Client client)
    {
        super(client);
    }

    /// List transactions across all databases.
    models.TransactionList listTransactions(string[] queries = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/tablesdb/transactions";

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
    models.Transaction createTransaction(long ttl = unset!long)
    {
        auto apiPath = "/tablesdb/transactions";

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
    models.Transaction getTransaction(string transactionId)
    {
        if (transactionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "transactionId"`);
        auto apiPath = "/tablesdb/transactions/{transactionId}"
            .replace("{transactionId}", encodeComponent(transactionId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Transaction)(apiResponse.json);
    }

    /// Update a transaction, to either commit or roll back its operations.
    models.Transaction updateTransaction(string transactionId, Nullable!(bool) commit = Nullable!(bool).init, Nullable!(bool) rollback = Nullable!(bool).init)
    {
        if (transactionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "transactionId"`);
        auto apiPath = "/tablesdb/transactions/{transactionId}"
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
    void deleteTransaction(string transactionId)
    {
        if (transactionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "transactionId"`);
        auto apiPath = "/tablesdb/transactions/{transactionId}"
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
    models.Transaction createOperations(string transactionId, JSONValue[] operations = null)
    {
        if (transactionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "transactionId"`);
        auto apiPath = "/tablesdb/transactions/{transactionId}/operations"
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

    /// Get a list of all the user's rows in a given table. You can use the query params
    /// to filter your results.
    models.RowList listRows(string databaseId, string tableId, string[] queries = null, string transactionId = null, Nullable!(bool) total = Nullable!(bool).init, long ttl = unset!long)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (tableId.length == 0)
            throw new AppwriteException(`Missing required parameter: "tableId"`);
        auto apiPath = "/tablesdb/{databaseId}/tables/{tableId}/rows"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{tableId}", encodeComponent(tableId));

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
        return deserialize!(models.RowList)(apiResponse.json);
    }

    /// Create a new Row. Before using this route, you should create a new table
    /// resource using either a [server
    /// integration](https://appwrite.io/docs/references/cloud/server-dart/tablesDB#createTable)
    /// API or directly from your database console.
    models.Row createRow(string databaseId, string tableId, string rowId, JSONValue data, string[] permissions = null, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (tableId.length == 0)
            throw new AppwriteException(`Missing required parameter: "tableId"`);
        auto apiPath = "/tablesdb/{databaseId}/tables/{tableId}/rows"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{tableId}", encodeComponent(tableId));

        JSONValue[string] apiParams;
        apiParams["rowId"] = serialize(rowId);
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
        return deserialize!(models.Row)(apiResponse.json);
    }

    /// Get a row by its unique ID. This endpoint response returns a JSON object with
    /// the row data.
    models.Row getRow(string databaseId, string tableId, string rowId, string[] queries = null, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (tableId.length == 0)
            throw new AppwriteException(`Missing required parameter: "tableId"`);
        if (rowId.length == 0)
            throw new AppwriteException(`Missing required parameter: "rowId"`);
        auto apiPath = "/tablesdb/{databaseId}/tables/{tableId}/rows/{rowId}"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{tableId}", encodeComponent(tableId))
            .replace("{rowId}", encodeComponent(rowId));

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (transactionId !is null)
            apiParams["transactionId"] = serialize(transactionId);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Row)(apiResponse.json);
    }

    /// Create or update a Row. Before using this route, you should create a new table
    /// resource using either a [server
    /// integration](https://appwrite.io/docs/references/cloud/server-dart/tablesDB#createTable)
    /// API or directly from your database console.
    models.Row upsertRow(string databaseId, string tableId, string rowId, JSONValue data = JSONValue.init, string[] permissions = null, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (tableId.length == 0)
            throw new AppwriteException(`Missing required parameter: "tableId"`);
        if (rowId.length == 0)
            throw new AppwriteException(`Missing required parameter: "rowId"`);
        auto apiPath = "/tablesdb/{databaseId}/tables/{tableId}/rows/{rowId}"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{tableId}", encodeComponent(tableId))
            .replace("{rowId}", encodeComponent(rowId));

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
        return deserialize!(models.Row)(apiResponse.json);
    }

    /// Update a row by its unique ID. Using the patch method you can pass only specific
    /// fields that will get updated.
    models.Row updateRow(string databaseId, string tableId, string rowId, JSONValue data = JSONValue.init, string[] permissions = null, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (tableId.length == 0)
            throw new AppwriteException(`Missing required parameter: "tableId"`);
        if (rowId.length == 0)
            throw new AppwriteException(`Missing required parameter: "rowId"`);
        auto apiPath = "/tablesdb/{databaseId}/tables/{tableId}/rows/{rowId}"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{tableId}", encodeComponent(tableId))
            .replace("{rowId}", encodeComponent(rowId));

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
        return deserialize!(models.Row)(apiResponse.json);
    }

    /// Delete a row by its unique ID.
    void deleteRow(string databaseId, string tableId, string rowId, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (tableId.length == 0)
            throw new AppwriteException(`Missing required parameter: "tableId"`);
        if (rowId.length == 0)
            throw new AppwriteException(`Missing required parameter: "rowId"`);
        auto apiPath = "/tablesdb/{databaseId}/tables/{tableId}/rows/{rowId}"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{tableId}", encodeComponent(tableId))
            .replace("{rowId}", encodeComponent(rowId));

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

    /// Decrement a specific column of a row by a given value.
    models.Row decrementRowColumn(string databaseId, string tableId, string rowId, string column, double value = unset!double, double min = unset!double, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (tableId.length == 0)
            throw new AppwriteException(`Missing required parameter: "tableId"`);
        if (rowId.length == 0)
            throw new AppwriteException(`Missing required parameter: "rowId"`);
        if (column.length == 0)
            throw new AppwriteException(`Missing required parameter: "column"`);
        auto apiPath = "/tablesdb/{databaseId}/tables/{tableId}/rows/{rowId}/{column}/decrement"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{tableId}", encodeComponent(tableId))
            .replace("{rowId}", encodeComponent(rowId))
            .replace("{column}", encodeComponent(column));

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
        return deserialize!(models.Row)(apiResponse.json);
    }

    /// Increment a specific column of a row by a given value.
    models.Row incrementRowColumn(string databaseId, string tableId, string rowId, string column, double value = unset!double, double max = unset!double, string transactionId = null)
    {
        if (databaseId.length == 0)
            throw new AppwriteException(`Missing required parameter: "databaseId"`);
        if (tableId.length == 0)
            throw new AppwriteException(`Missing required parameter: "tableId"`);
        if (rowId.length == 0)
            throw new AppwriteException(`Missing required parameter: "rowId"`);
        if (column.length == 0)
            throw new AppwriteException(`Missing required parameter: "column"`);
        auto apiPath = "/tablesdb/{databaseId}/tables/{tableId}/rows/{rowId}/{column}/increment"
            .replace("{databaseId}", encodeComponent(databaseId))
            .replace("{tableId}", encodeComponent(tableId))
            .replace("{rowId}", encodeComponent(rowId))
            .replace("{column}", encodeComponent(column));

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
        return deserialize!(models.Row)(apiResponse.json);
    }
}
