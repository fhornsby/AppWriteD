module appwrite.models.membership_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Memberships List
struct MembershipList
{
    /// Total number of memberships that matched your query.
    @jsonKey("total") long total;

    /// List of memberships.
    @jsonKey("memberships") models.Membership[] memberships;

    /// Parse a `MembershipList` from JSON.
    static MembershipList fromJson(JSONValue json)
    {
        return deserialize!(MembershipList)(json);
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
