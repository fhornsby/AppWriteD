module appwrite.models.app_scope;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// AppScope
struct AppScope
{
    /// Scope value as requested by apps.
    @jsonKey("value") string value;

    /// Human-readable description of what the scope grants.
    @jsonKey("description") string description;

    /// What the scope grants access to. One of `account`, `project`, or `organization`.
    /// Only `project` and `organization` scopes are installable.
    @jsonKey("type") string type;

    /// Scope category, used to group scopes on consent and installation screens.
    @jsonKey("category") string category;

    /// Whether the scope is deprecated. Deprecated scopes can still be requested but
    /// should not be offered for new grants.
    @jsonKey("deprecated") bool deprecated_ = false;

    /// Parse a `AppScope` from JSON.
    static AppScope fromJson(JSONValue json)
    {
        return deserialize!(AppScope)(json);
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
