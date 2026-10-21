module appwrite.models.session;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Session
struct Session
{
    /// Session ID.
    @jsonKey("$id") string id;

    /// Session creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Session update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// User ID.
    @jsonKey("userId") string userId;

    /// Session expiration date in ISO 8601 format.
    @jsonKey("expire") string expire;

    /// Session Provider.
    @jsonKey("provider") string provider;

    /// Session Provider User ID.
    @jsonKey("providerUid") string providerUid;

    /// Session Provider Access Token.
    @jsonKey("providerAccessToken") string providerAccessToken;

    /// The date of when the access token expires in ISO 8601 format.
    @jsonKey("providerAccessTokenExpiry") string providerAccessTokenExpiry;

    /// Session Provider Refresh Token.
    @jsonKey("providerRefreshToken") string providerRefreshToken;

    /// IP in use when the session was created.
    @jsonKey("ip") string ip;

    /// Operating system code name. View list of [available
    /// options](https://github.com/appwrite/appwrite/blob/master/docs/lists/os.json).
    @jsonKey("osCode") string osCode;

    /// Operating system name.
    @jsonKey("osName") string osName;

    /// Operating system version.
    @jsonKey("osVersion") string osVersion;

    /// Client type.
    @jsonKey("clientType") string clientType;

    /// Client code name. View list of [available
    /// options](https://github.com/appwrite/appwrite/blob/master/docs/lists/clients.json).
    @jsonKey("clientCode") string clientCode;

    /// Client name.
    @jsonKey("clientName") string clientName;

    /// Client version.
    @jsonKey("clientVersion") string clientVersion;

    /// Client engine name.
    @jsonKey("clientEngine") string clientEngine;

    /// Client engine name.
    @jsonKey("clientEngineVersion") string clientEngineVersion;

    /// Device name.
    @jsonKey("deviceName") string deviceName;

    /// Device brand name.
    @jsonKey("deviceBrand") string deviceBrand;

    /// Device model name.
    @jsonKey("deviceModel") string deviceModel;

    /// Country two-character ISO 3166-1 alpha code.
    @jsonKey("countryCode") string countryCode;

    /// Country name.
    @jsonKey("countryName") string countryName;

    /// Returns true if this the current user session.
    @jsonKey("current") bool current = false;

    /// Returns a list of active session factors.
    @jsonKey("factors") string[] factors;

    /// Secret used to authenticate the user. Only included if the request was made with
    /// an API key
    @jsonKey("secret") string secret;

    /// Most recent date in ISO 8601 format when the session successfully passed MFA
    /// challenge.
    @jsonKey("mfaUpdatedAt") string mfaUpdatedAt;

    /// Parse a `Session` from JSON.
    static Session fromJson(JSONValue json)
    {
        return deserialize!(Session)(json);
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
