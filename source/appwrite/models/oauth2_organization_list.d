module appwrite.models.oauth2_organization_list;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// OAuth2 accessible organizations list
struct Oauth2OrganizationList
{
    /// Total number of organizations that matched your query.
    @jsonKey("total") long total;

    /// List of organizations.
    @jsonKey("organizations") models.Oauth2Organization[] organizations;

    /// Parse a `Oauth2OrganizationList` from JSON.
    static Oauth2OrganizationList fromJson(JSONValue json)
    {
        return deserialize!(Oauth2OrganizationList)(json);
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
