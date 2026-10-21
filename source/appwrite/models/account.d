module appwrite.models.account;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Account
struct Account
{
    /// User ID.
    @jsonKey("$id") string id;

    /// User creation date in ISO 8601 format.
    @jsonKey("$createdAt") string createdAt;

    /// User update date in ISO 8601 format.
    @jsonKey("$updatedAt") string updatedAt;

    /// User name.
    @jsonKey("name") string name;

    /// User registration date in ISO 8601 format.
    @jsonKey("registration") string registration;

    /// User status. Pass `true` for enabled and `false` for disabled.
    @jsonKey("status") bool status = true;

    /// Labels for the user.
    @jsonKey("labels") string[] labels;

    /// Password update time in ISO 8601 format.
    @jsonKey("passwordUpdate") string passwordUpdate;

    /// User email address.
    @jsonKey("email") string email;

    /// User phone number in E.164 format.
    @jsonKey("phone") string phone;

    /// Email verification status.
    @jsonKey("emailVerification") bool emailVerification = false;

    /// Canonical form of the user email address.
    @jsonKey("emailCanonical") string emailCanonical;

    /// Whether the user email is from a free email provider.
    @jsonKey("emailIsFree") Nullable!(bool) emailIsFree;

    /// Whether the user email is from a disposable email provider.
    @jsonKey("emailIsDisposable") Nullable!(bool) emailIsDisposable;

    /// Whether the user email is from a corporate domain.
    @jsonKey("emailIsCorporate") Nullable!(bool) emailIsCorporate;

    /// Whether the user email is in its canonical form.
    @jsonKey("emailIsCanonical") Nullable!(bool) emailIsCanonical;

    /// Whether the password was found in a known data breach the last time it was
    /// checked. Null when the password has never been checked.
    @jsonKey("passwordPwned") Nullable!(bool) passwordPwned;

    /// Phone verification status.
    @jsonKey("phoneVerification") bool phoneVerification = false;

    /// Multi factor authentication status.
    @jsonKey("mfa") bool mfa = false;

    /// User preferences as a key-value object
    @jsonKey("prefs") models.Preferences prefs;

    /// A user-owned message receiver. A single user may have multiple e.g. emails,
    /// phones, and a browser. Each target is registered with a single provider.
    @jsonKey("targets") models.Target[] targets;

    /// Most recent access date in ISO 8601 format. This attribute is only updated again
    /// after 24 hours.
    @jsonKey("accessedAt") string accessedAt;

    /// Whether the user can impersonate other users.
    @jsonKey("impersonator") Nullable!(bool) impersonator;

    /// ID of the original actor performing the impersonation. Present only when the
    /// current request is impersonating another user. Internal audit logs attribute the
    /// action to this user, while the impersonated target is recorded only in internal
    /// audit payload data.
    @jsonKey("impersonatorUserId") string impersonatorUserId;

    /// Parse a `Account` from JSON.
    static Account fromJson(JSONValue json)
    {
        return deserialize!(Account)(json);
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
