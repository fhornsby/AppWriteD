module appwrite.models.execution_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Executions List
struct ExecutionList
{
    /// Total number of executions that matched your query.
    @jsonKey("total") long total;

    /// List of executions.
    @jsonKey("executions") models.Execution[] executions;

    /// Parse a `ExecutionList` from JSON.
    static ExecutionList fromJson(JSONValue json)
    {
        return deserialize!(ExecutionList)(json);
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
