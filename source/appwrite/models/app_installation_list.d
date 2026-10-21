module appwrite.models.app_installation_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// App installations list
struct AppInstallationList
{
    /// Total number of installations that matched your query.
    @jsonKey("total") long total;

    /// List of installations.
    @jsonKey("installations") models.AppInstallation[] installations;

    /// Parse a `AppInstallationList` from JSON.
    static AppInstallationList fromJson(JSONValue json)
    {
        return deserialize!(AppInstallationList)(json);
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
