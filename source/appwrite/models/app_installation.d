module appwrite.models.app_installation;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// AppInstallation
struct AppInstallation
{
    /// Installation ID.
    @jsonKey("$id") string id;

    /// Installation creation time in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Installation update time in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// ID of the installed application.
    @jsonKey("appId") string appId;

    /// ID of the team the application is installed on.
    @jsonKey("teamId") string teamId;

    /// Scopes granted to the application. Snapshot of the application's installation
    /// scopes taken when the installation was created or last updated.
    @jsonKey("scopes") string[] scopes;

    /// Authorization details granted to the application. Rich authorization request
    /// (RFC 9396) style entries; the Appwrite Console stores authorized project IDs
    /// here.
    @jsonKey("authorizationDetails") JSONValue[] authorizationDetails;

    /// ID of the user who created the installation.
    @jsonKey("createdById") string createdById;

    /// Name of the user who created the installation.
    @jsonKey("createdByName") string createdByName;

    /// Time an access token was last issued for the installation in ISO 8601 format.
    /// Null if never used.
    @jsonKey("lastAccessedAt") string lastAccessedAt;

    /// Parse a `AppInstallation` from JSON.
    static AppInstallation fromJson(JSONValue json)
    {
        return deserialize!(AppInstallation)(json);
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
