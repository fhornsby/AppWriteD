module appwrite.exception;

/**
 * Thrown when a request fails: the server answered with an error, the network
 * failed, or the SDK was used incorrectly (a required parameter was empty, for
 * instance).
 */
class AppwriteException : Exception
{
    /// HTTP status code, or the error code the server reported. 0 when no response arrived.
    int code;

    /// Error type, e.g. `user_unauthorized`.
    /// See https://appwrite.io/docs/advanced/platform/response-codes
    string type;

    /// The raw response body, when there was one.
    string response;

    this(string message, int code = 0, string type = null, string response = null,
        string file = __FILE__, size_t line = __LINE__, Throwable next = null) @safe pure nothrow
    {
        super(message, file, line, next);
        this.code = code;
        this.type = type;
        this.response = response;
    }

    override string toString() const @safe
    {
        import std.format : format;

        if (msg.length == 0)
            return "AppwriteException";
        return format("AppwriteException: %s, %s (%s)", type, msg, code);
    }
}
