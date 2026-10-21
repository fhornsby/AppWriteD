module appwrite.models.membership;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Membership
struct Membership
{
    /// Membership ID.
    @jsonKey("$id") string id;

    /// Membership creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// Membership update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// User ID.
    @jsonKey("userId") string userId;

    /// User name. Hide this attribute by toggling membership privacy in the Console.
    @jsonKey("userName") string userName;

    /// User email address. Hide this attribute by toggling membership privacy in the
    /// Console.
    @jsonKey("userEmail") string userEmail;

    /// User phone number. Hide this attribute by toggling membership privacy in the
    /// Console.
    @jsonKey("userPhone") string userPhone;

    /// Team ID.
    @jsonKey("teamId") string teamId;

    /// Team name.
    @jsonKey("teamName") string teamName;

    /// Date, the user has been invited to join the team in ISO 8601 format.
    @jsonKey("invited") string invited;

    /// Date, the user has accepted the invitation to join the team in ISO 8601 format.
    @jsonKey("joined") string joined;

    /// User confirmation status, true if the user has joined the team or false
    /// otherwise.
    @jsonKey("confirm") bool confirm = false;

    /// Multi factor authentication status, true if the user has MFA enabled or false
    /// otherwise. Hide this attribute by toggling membership privacy in the Console.
    @jsonKey("mfa") bool mfa = false;

    /// Most recent access date in ISO 8601 format. Show this attribute by toggling
    /// membership privacy in the Console.
    @jsonKey("userAccessedAt") string userAccessedAt;

    /// User list of roles
    @jsonKey("roles") string[] roles;

    /// Parse a `Membership` from JSON.
    static Membership fromJson(JSONValue json)
    {
        return deserialize!(Membership)(json);
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
