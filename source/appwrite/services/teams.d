module appwrite.services.teams;

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

/// The Teams service allows you to group users of your project and to enable them
/// to share read and write access to your project resources
class Teams : Service
{
    this(Client client)
    {
        super(client);
    }

    /// Get a list of all the teams in which the current user is a member. You can use
    /// the parameters to filter your results.
    models.TeamList list(string[] queries = null, string search = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/teams";

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (search !is null)
            apiParams["search"] = serialize(search);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.TeamList)(apiResponse.json);
    }

    /// Create a new team. The user who creates the team will automatically be assigned
    /// as the owner of the team. Only the users with the owner role can invite new
    /// members, add new owners and delete or update the team.
    models.Team create(string teamId, string name, string[] roles = null)
    {
        auto apiPath = "/teams";

        JSONValue[string] apiParams;
        apiParams["teamId"] = serialize(teamId);
        apiParams["name"] = serialize(name);
        if (roles !is null)
            apiParams["roles"] = serialize(roles);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Team)(apiResponse.json);
    }

    /// Get a team by its ID. All team members have read access for this resource.
    models.Team get(string teamId)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        auto apiPath = "/teams/{teamId}"
            .replace("{teamId}", encodeComponent(teamId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Team)(apiResponse.json);
    }

    /// Update the team's name by its unique ID.
    models.Team updateName(string teamId, string name)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        auto apiPath = "/teams/{teamId}"
            .replace("{teamId}", encodeComponent(teamId));

        JSONValue[string] apiParams;
        apiParams["name"] = serialize(name);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Team)(apiResponse.json);
    }

    /// Delete a team using its ID. Only team members with the owner role can delete the
    /// team.
    void delete_(string teamId)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        auto apiPath = "/teams/{teamId}"
            .replace("{teamId}", encodeComponent(teamId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// List app installations on a team. Any team member can read installations.
    models.AppInstallationList listInstallations(string teamId, string[] queries = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        auto apiPath = "/teams/{teamId}/installations"
            .replace("{teamId}", encodeComponent(teamId));

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppInstallationList)(apiResponse.json);
    }

    /// Install an app on a team. When authenticated as a user, only team members with
    /// the owner role can install apps. Requests using an API key or in admin mode can
    /// install apps on any team. The installation is granted the scopes the app
    /// currently requests.
    models.AppInstallation createInstallation(string teamId, string appId, string authorizationDetails = null)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        auto apiPath = "/teams/{teamId}/installations"
            .replace("{teamId}", encodeComponent(teamId));

        JSONValue[string] apiParams;
        apiParams["appId"] = serialize(appId);
        if (authorizationDetails !is null)
            apiParams["authorizationDetails"] = serialize(authorizationDetails);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppInstallation)(apiResponse.json);
    }

    /// Get an app installation on a team by its unique ID. Any team member can read
    /// installations.
    models.AppInstallation getInstallation(string teamId, string installationId)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        if (installationId.length == 0)
            throw new AppwriteException(`Missing required parameter: "installationId"`);
        auto apiPath = "/teams/{teamId}/installations/{installationId}"
            .replace("{teamId}", encodeComponent(teamId))
            .replace("{installationId}", encodeComponent(installationId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppInstallation)(apiResponse.json);
    }

    /// Update an app installation on a team. Only team members with the owner role can
    /// update installations. The installation's granted scopes are refreshed to the
    /// scopes the app currently requests; previously issued installation access tokens
    /// are revoked.
    models.AppInstallation updateInstallation(string teamId, string installationId, string authorizationDetails = null)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        if (installationId.length == 0)
            throw new AppwriteException(`Missing required parameter: "installationId"`);
        auto apiPath = "/teams/{teamId}/installations/{installationId}"
            .replace("{teamId}", encodeComponent(teamId))
            .replace("{installationId}", encodeComponent(installationId));

        JSONValue[string] apiParams;
        if (authorizationDetails !is null)
            apiParams["authorizationDetails"] = serialize(authorizationDetails);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.AppInstallation)(apiResponse.json);
    }

    /// Uninstall an app from a team by its installation ID. Only team members with the
    /// owner role can remove installations. Previously issued installation access
    /// tokens are revoked.
    void deleteInstallation(string teamId, string installationId)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        if (installationId.length == 0)
            throw new AppwriteException(`Missing required parameter: "installationId"`);
        auto apiPath = "/teams/{teamId}/installations/{installationId}"
            .replace("{teamId}", encodeComponent(teamId))
            .replace("{installationId}", encodeComponent(installationId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Use this endpoint to list a team's members using the team's ID. All team members
    /// have read access to this endpoint. Hide sensitive attributes from the response
    /// by toggling membership privacy in the Console.
    models.MembershipList listMemberships(string teamId, string[] queries = null, string search = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        auto apiPath = "/teams/{teamId}/memberships"
            .replace("{teamId}", encodeComponent(teamId));

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (search !is null)
            apiParams["search"] = serialize(search);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.MembershipList)(apiResponse.json);
    }

    /// Invite a new member to join your team. Provide an ID for existing users, or
    /// invite unregistered users using an email or phone number. If initiated from a
    /// Client SDK, Appwrite will send an email or sms with a link to join the team to
    /// the invited user, and an account will be created for them if one doesn't exist.
    /// If initiated from a Server SDK, the new member will be added automatically to
    /// the team.
    ///
    /// You only need to provide one of a user ID, email, or phone number. Appwrite will
    /// prioritize accepting the user ID > email > phone number if you provide more than
    /// one of these parameters.
    ///
    /// Use the `url` parameter to redirect the user from the invitation email to your
    /// app. After the user is redirected, use the [Update Team Membership
    /// Status](https://appwrite.io/docs/references/cloud/client-web/teams#updateMembershipStatus)
    /// endpoint to allow the user to accept the invitation to the team.
    ///
    /// Please note that to avoid a [Redirect
    /// Attack](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.md)
    /// Appwrite will accept the only redirect URLs under the domains you have added as
    /// a platform on the Appwrite Console.
    models.Membership createMembership(string teamId, string[] roles, string email = null, string userId = null, string phone = null, string url = null, string name = null, string membershipId = null)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        auto apiPath = "/teams/{teamId}/memberships"
            .replace("{teamId}", encodeComponent(teamId));

        JSONValue[string] apiParams;
        if (email !is null)
            apiParams["email"] = serialize(email);
        if (userId !is null)
            apiParams["userId"] = serialize(userId);
        if (phone !is null)
            apiParams["phone"] = serialize(phone);
        apiParams["roles"] = serialize(roles);
        if (url !is null)
            apiParams["url"] = serialize(url);
        if (name !is null)
            apiParams["name"] = serialize(name);
        if (membershipId !is null)
            apiParams["membershipId"] = serialize(membershipId);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Membership)(apiResponse.json);
    }

    /// Get a team member by the membership unique id. All team members have read access
    /// for this resource. Hide sensitive attributes from the response by toggling
    /// membership privacy in the Console.
    models.Membership getMembership(string teamId, string membershipId)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        if (membershipId.length == 0)
            throw new AppwriteException(`Missing required parameter: "membershipId"`);
        auto apiPath = "/teams/{teamId}/memberships/{membershipId}"
            .replace("{teamId}", encodeComponent(teamId))
            .replace("{membershipId}", encodeComponent(membershipId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Membership)(apiResponse.json);
    }

    /// Modify the roles of a team member. Only team members with the owner role have
    /// access to this endpoint. Learn more about [roles and
    /// permissions](https://appwrite.io/docs/permissions).
    models.Membership updateMembership(string teamId, string membershipId, string[] roles)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        if (membershipId.length == 0)
            throw new AppwriteException(`Missing required parameter: "membershipId"`);
        auto apiPath = "/teams/{teamId}/memberships/{membershipId}"
            .replace("{teamId}", encodeComponent(teamId))
            .replace("{membershipId}", encodeComponent(membershipId));

        JSONValue[string] apiParams;
        apiParams["roles"] = serialize(roles);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Membership)(apiResponse.json);
    }

    /// This endpoint allows a user to leave a team or for a team owner to delete the
    /// membership of any other team member. You can also use this endpoint to delete a
    /// user membership even if it is not accepted.
    void deleteMembership(string teamId, string membershipId)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        if (membershipId.length == 0)
            throw new AppwriteException(`Missing required parameter: "membershipId"`);
        auto apiPath = "/teams/{teamId}/memberships/{membershipId}"
            .replace("{teamId}", encodeComponent(teamId))
            .replace("{membershipId}", encodeComponent(membershipId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Use this endpoint to allow a user to accept an invitation to join a team after
    /// being redirected back to your app from the invitation email received by the
    /// user.
    ///
    /// If the request is successful, a session for the user is automatically created.
    models.Membership updateMembershipStatus(string teamId, string membershipId, string userId, string secret)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        if (membershipId.length == 0)
            throw new AppwriteException(`Missing required parameter: "membershipId"`);
        auto apiPath = "/teams/{teamId}/memberships/{membershipId}/status"
            .replace("{teamId}", encodeComponent(teamId))
            .replace("{membershipId}", encodeComponent(membershipId));

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["secret"] = serialize(secret);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Membership)(apiResponse.json);
    }

    /// Get the team's shared preferences by its unique ID. If a preference doesn't need
    /// to be shared by all team members, prefer storing them in [user
    /// preferences](https://appwrite.io/docs/references/cloud/client-web/account#getPrefs).
    models.Preferences getPrefs(string teamId)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        auto apiPath = "/teams/{teamId}/prefs"
            .replace("{teamId}", encodeComponent(teamId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Preferences)(apiResponse.json);
    }

    /// Update the team's preferences by its unique ID. The object you pass is stored as
    /// is and replaces any previous value. The maximum allowed prefs size is 64kB and
    /// throws an error if exceeded.
    models.Preferences updatePrefs(string teamId, JSONValue prefs)
    {
        if (teamId.length == 0)
            throw new AppwriteException(`Missing required parameter: "teamId"`);
        auto apiPath = "/teams/{teamId}/prefs"
            .replace("{teamId}", encodeComponent(teamId));

        JSONValue[string] apiParams;
        apiParams["prefs"] = serialize(prefs);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Preferences)(apiResponse.json);
    }
}
