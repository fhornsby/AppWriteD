module appwrite.permission;

/**
 * Helpers for permission strings, used with `Role`:
 *
 * ---
 * [Permission.read(Role.any()), Permission.update(Role.user(userId))]
 * ---
 */
struct Permission
{
    @disable this();

    /// Read access for `role`.
    static string read(string role)
    {
        return `read("` ~ role ~ `")`;
    }

    /// Write access for `role`: an alias of update, delete and possibly create.
    /// Don't combine write with update, delete or create.
    static string write(string role)
    {
        return `write("` ~ role ~ `")`;
    }

    /// Create access for `role`.
    static string create(string role)
    {
        return `create("` ~ role ~ `")`;
    }

    /// Update access for `role`.
    static string update(string role)
    {
        return `update("` ~ role ~ `")`;
    }

    /// Delete access for `role`.
    static string delete_(string role)
    {
        return `delete("` ~ role ~ `")`;
    }
}

unittest
{
    import appwrite.role : Role;

    assert(Permission.read(Role.any()) == `read("any")`);
    assert(Permission.delete_(Role.team("teamId", "owner")) == `delete("team:teamId/owner")`);
}

