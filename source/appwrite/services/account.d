module appwrite.services.account;

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

/// The Account service allows you to authenticate and manage a user account.
class Account : Service
{
    this(Client client)
    {
        super(client);
    }

    /// Get the currently logged in user.
    models.User get()
    {
        auto apiPath = "/account";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.User)(apiResponse.json);
    }

    /// Use this endpoint to allow a new user to register a new account in your project.
    /// After the user registration completes successfully, you can use the
    /// [/account/verfication](https://appwrite.io/docs/references/cloud/client-web/account#createVerification)
    /// route to start verifying the user email address. To allow the new user to login
    /// to their new account, you need to create a new [account
    /// session](https://appwrite.io/docs/references/cloud/client-web/account#createEmailSession).
    models.User create(string userId, string email, string password, string name = null)
    {
        auto apiPath = "/account";

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["email"] = serialize(email);
        apiParams["password"] = serialize(password);
        if (name !is null)
            apiParams["name"] = serialize(name);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.User)(apiResponse.json);
    }

    /// Get a list of the OAuth2 consents the current user has given to third-party
    /// apps.
    models.Oauth2ConsentList listConsents(string[] queries = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/account/consents";

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2ConsentList)(apiResponse.json);
    }

    /// Get an OAuth2 consent the current user has given to a third-party app by its
    /// unique ID.
    models.Oauth2Consent getConsent(string consentId)
    {
        if (consentId.length == 0)
            throw new AppwriteException(`Missing required parameter: "consentId"`);
        auto apiPath = "/account/consents/{consentId}"
            .replace("{consentId}", encodeComponent(consentId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2Consent)(apiResponse.json);
    }

    /// Delete an OAuth2 consent by its unique ID. All token families issued under the
    /// consent are revoked, and the app must ask for consent again to regain access.
    void deleteConsent(string consentId)
    {
        if (consentId.length == 0)
            throw new AppwriteException(`Missing required parameter: "consentId"`);
        auto apiPath = "/account/consents/{consentId}"
            .replace("{consentId}", encodeComponent(consentId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Get a list of the token families issued under an OAuth2 consent. Each entry
    /// represents one authorized device or session; the token secrets themselves are
    /// never returned.
    models.Oauth2ConsentTokenList listConsentTokens(string consentId, string[] queries = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        if (consentId.length == 0)
            throw new AppwriteException(`Missing required parameter: "consentId"`);
        auto apiPath = "/account/consents/{consentId}/tokens"
            .replace("{consentId}", encodeComponent(consentId));

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2ConsentTokenList)(apiResponse.json);
    }

    /// Get a token family issued under an OAuth2 consent by its unique ID. The token
    /// secrets themselves are never returned.
    models.Oauth2ConsentToken getConsentToken(string consentId, string tokenId)
    {
        if (consentId.length == 0)
            throw new AppwriteException(`Missing required parameter: "consentId"`);
        if (tokenId.length == 0)
            throw new AppwriteException(`Missing required parameter: "tokenId"`);
        auto apiPath = "/account/consents/{consentId}/tokens/{tokenId}"
            .replace("{consentId}", encodeComponent(consentId))
            .replace("{tokenId}", encodeComponent(tokenId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Oauth2ConsentToken)(apiResponse.json);
    }

    /// Delete a token family issued under an OAuth2 consent by its unique ID. The
    /// access and refresh tokens of the family stop working immediately; other token
    /// families and the consent itself are unaffected.
    void deleteConsentToken(string consentId, string tokenId)
    {
        if (consentId.length == 0)
            throw new AppwriteException(`Missing required parameter: "consentId"`);
        if (tokenId.length == 0)
            throw new AppwriteException(`Missing required parameter: "tokenId"`);
        auto apiPath = "/account/consents/{consentId}/tokens/{tokenId}"
            .replace("{consentId}", encodeComponent(consentId))
            .replace("{tokenId}", encodeComponent(tokenId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Update currently logged in user account email address. After changing user
    /// address, the user confirmation status will get reset. A new confirmation email
    /// is not sent automatically however you can use the send confirmation email
    /// endpoint again to send the confirmation email. For security measures, user
    /// password is required to complete this request.
    /// This endpoint can also be used to convert an anonymous account to a normal one,
    /// by passing an email address and a new password.
    models.User updateEmail(string email, string password)
    {
        auto apiPath = "/account/email";

        JSONValue[string] apiParams;
        apiParams["email"] = serialize(email);
        apiParams["password"] = serialize(password);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.User)(apiResponse.json);
    }

    /// Get the list of identities for the currently logged in user.
    models.IdentityList listIdentities(string[] queries = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/account/identities";

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.IdentityList)(apiResponse.json);
    }

    /// Delete an identity by its unique ID.
    void deleteIdentity(string identityId)
    {
        if (identityId.length == 0)
            throw new AppwriteException(`Missing required parameter: "identityId"`);
        auto apiPath = "/account/identities/{identityId}"
            .replace("{identityId}", encodeComponent(identityId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Use this endpoint to create a JSON Web Token. You can use the resulting JWT to
    /// authenticate on behalf of the current user when working with the Appwrite
    /// server-side API and SDKs. The JWT secret is valid for 15 minutes from its
    /// creation and will be invalid if the user will logout in that time frame.
    models.Jwt createJWT(long duration = unset!long)
    {
        auto apiPath = "/account/jwts";

        JSONValue[string] apiParams;
        if (isSet(duration))
            apiParams["duration"] = serialize(duration);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Jwt)(apiResponse.json);
    }

    /// Enable or disable MFA on an account.
    models.User updateMFA(bool mfa)
    {
        auto apiPath = "/account/mfa";

        JSONValue[string] apiParams;
        apiParams["mfa"] = serialize(mfa);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.User)(apiResponse.json);
    }

    /// Add an authenticator app to be used as an MFA factor. Verify the authenticator
    /// using the [verify
    /// authenticator](/docs/references/cloud/client-web/account#updateMfaAuthenticator)
    /// method.
    deprecated("This API has been deprecated since 1.8.0. Please use `account.createMFAAuthenticator` instead.")
    models.MfaType createMfaAuthenticator(enums.AuthenticatorType type)
    {
        auto apiPath = "/account/mfa/authenticators/{type}"
            .replace("{type}", encodeComponent(cast(string) type));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.MfaType)(apiResponse.json);
    }

    /// Add an authenticator app to be used as an MFA factor. Verify the authenticator
    /// using the [verify
    /// authenticator](/docs/references/cloud/client-web/account#updateMfaAuthenticator)
    /// method.
    models.MfaType createMFAAuthenticator(enums.AuthenticatorType type)
    {
        auto apiPath = "/account/mfa/authenticators/{type}"
            .replace("{type}", encodeComponent(cast(string) type));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.MfaType)(apiResponse.json);
    }

    /// Verify an authenticator app after adding it using the [add
    /// authenticator](/docs/references/cloud/client-web/account#createMfaAuthenticator)
    /// method.
    deprecated("This API has been deprecated since 1.8.0. Please use `account.updateMFAAuthenticator` instead.")
    models.User updateMfaAuthenticator(enums.AuthenticatorType type, string otp)
    {
        auto apiPath = "/account/mfa/authenticators/{type}"
            .replace("{type}", encodeComponent(cast(string) type));

        JSONValue[string] apiParams;
        apiParams["otp"] = serialize(otp);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.User)(apiResponse.json);
    }

    /// Verify an authenticator app after adding it using the [add
    /// authenticator](/docs/references/cloud/client-web/account#createMfaAuthenticator)
    /// method.
    models.User updateMFAAuthenticator(enums.AuthenticatorType type, string otp)
    {
        auto apiPath = "/account/mfa/authenticators/{type}"
            .replace("{type}", encodeComponent(cast(string) type));

        JSONValue[string] apiParams;
        apiParams["otp"] = serialize(otp);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.User)(apiResponse.json);
    }

    /// Delete an authenticator for a user by ID.
    deprecated("This API has been deprecated since 1.8.0. Please use `account.deleteMFAAuthenticator` instead.")
    void deleteMfaAuthenticator(enums.AuthenticatorType type)
    {
        auto apiPath = "/account/mfa/authenticators/{type}"
            .replace("{type}", encodeComponent(cast(string) type));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Delete an authenticator for a user by ID.
    void deleteMFAAuthenticator(enums.AuthenticatorType type)
    {
        auto apiPath = "/account/mfa/authenticators/{type}"
            .replace("{type}", encodeComponent(cast(string) type));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Begin the process of MFA verification after sign-in. Finish the flow with
    /// [updateMfaChallenge](/docs/references/cloud/client-web/account#updateMfaChallenge)
    /// method.
    deprecated("This API has been deprecated since 1.8.0. Please use `account.createMFAChallenge` instead.")
    models.MfaChallenge createMfaChallenge(enums.AuthenticationFactor factor)
    {
        auto apiPath = "/account/mfa/challenges";

        JSONValue[string] apiParams;
        apiParams["factor"] = serialize(factor);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.MfaChallenge)(apiResponse.json);
    }

    /// Begin the process of MFA verification after sign-in. Finish the flow with
    /// [updateMfaChallenge](/docs/references/cloud/client-web/account#updateMfaChallenge)
    /// method.
    models.MfaChallenge createMFAChallenge(enums.AuthenticationFactor factor)
    {
        auto apiPath = "/account/mfa/challenges";

        JSONValue[string] apiParams;
        apiParams["factor"] = serialize(factor);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.MfaChallenge)(apiResponse.json);
    }

    /// Complete the MFA challenge by providing the one-time password. Finish the
    /// process of MFA verification by providing the one-time password. To begin the
    /// flow, use
    /// [createMfaChallenge](/docs/references/cloud/client-web/account#createMfaChallenge)
    /// method.
    deprecated("This API has been deprecated since 1.8.0. Please use `account.updateMFAChallenge` instead.")
    models.Session updateMfaChallenge(string challengeId, string otp)
    {
        auto apiPath = "/account/mfa/challenges";

        JSONValue[string] apiParams;
        apiParams["challengeId"] = serialize(challengeId);
        apiParams["otp"] = serialize(otp);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Session)(apiResponse.json);
    }

    /// Complete the MFA challenge by providing the one-time password. Finish the
    /// process of MFA verification by providing the one-time password. To begin the
    /// flow, use
    /// [createMfaChallenge](/docs/references/cloud/client-web/account#createMfaChallenge)
    /// method.
    models.Session updateMFAChallenge(string challengeId, string otp)
    {
        auto apiPath = "/account/mfa/challenges";

        JSONValue[string] apiParams;
        apiParams["challengeId"] = serialize(challengeId);
        apiParams["otp"] = serialize(otp);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Session)(apiResponse.json);
    }

    /// List the factors available on the account to be used as a MFA challange.
    deprecated("This API has been deprecated since 1.8.0. Please use `account.listMFAFactors` instead.")
    models.MfaFactors listMfaFactors()
    {
        auto apiPath = "/account/mfa/factors";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.MfaFactors)(apiResponse.json);
    }

    /// List the factors available on the account to be used as a MFA challange.
    models.MfaFactors listMFAFactors()
    {
        auto apiPath = "/account/mfa/factors";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.MfaFactors)(apiResponse.json);
    }

    /// Get recovery codes that can be used as backup for MFA flow. Before getting
    /// codes, they must be generated using
    /// [createMfaRecoveryCodes](/docs/references/cloud/client-web/account#createMfaRecoveryCodes)
    /// method. An OTP challenge is required to read recovery codes.
    deprecated("This API has been deprecated since 1.8.0. Please use `account.getMFARecoveryCodes` instead.")
    models.MfaRecoveryCodes getMfaRecoveryCodes()
    {
        auto apiPath = "/account/mfa/recovery-codes";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.MfaRecoveryCodes)(apiResponse.json);
    }

    /// Get recovery codes that can be used as backup for MFA flow. Before getting
    /// codes, they must be generated using
    /// [createMfaRecoveryCodes](/docs/references/cloud/client-web/account#createMfaRecoveryCodes)
    /// method. An OTP challenge is required to read recovery codes.
    models.MfaRecoveryCodes getMFARecoveryCodes()
    {
        auto apiPath = "/account/mfa/recovery-codes";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.MfaRecoveryCodes)(apiResponse.json);
    }

    /// Generate recovery codes as backup for MFA flow. It's recommended to generate and
    /// show then immediately after user successfully adds their authehticator. Recovery
    /// codes can be used as a MFA verification type in
    /// [createMfaChallenge](/docs/references/cloud/client-web/account#createMfaChallenge)
    /// method.
    deprecated("This API has been deprecated since 1.8.0. Please use `account.createMFARecoveryCodes` instead.")
    models.MfaRecoveryCodes createMfaRecoveryCodes()
    {
        auto apiPath = "/account/mfa/recovery-codes";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.MfaRecoveryCodes)(apiResponse.json);
    }

    /// Generate recovery codes as backup for MFA flow. It's recommended to generate and
    /// show then immediately after user successfully adds their authehticator. Recovery
    /// codes can be used as a MFA verification type in
    /// [createMfaChallenge](/docs/references/cloud/client-web/account#createMfaChallenge)
    /// method.
    models.MfaRecoveryCodes createMFARecoveryCodes()
    {
        auto apiPath = "/account/mfa/recovery-codes";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.MfaRecoveryCodes)(apiResponse.json);
    }

    /// Regenerate recovery codes that can be used as backup for MFA flow. Before
    /// regenerating codes, they must be first generated using
    /// [createMfaRecoveryCodes](/docs/references/cloud/client-web/account#createMfaRecoveryCodes)
    /// method. An OTP challenge is required to regenreate recovery codes.
    deprecated("This API has been deprecated since 1.8.0. Please use `account.updateMFARecoveryCodes` instead.")
    models.MfaRecoveryCodes updateMfaRecoveryCodes()
    {
        auto apiPath = "/account/mfa/recovery-codes";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.MfaRecoveryCodes)(apiResponse.json);
    }

    /// Regenerate recovery codes that can be used as backup for MFA flow. Before
    /// regenerating codes, they must be first generated using
    /// [createMfaRecoveryCodes](/docs/references/cloud/client-web/account#createMfaRecoveryCodes)
    /// method. An OTP challenge is required to regenreate recovery codes.
    models.MfaRecoveryCodes updateMFARecoveryCodes()
    {
        auto apiPath = "/account/mfa/recovery-codes";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.MfaRecoveryCodes)(apiResponse.json);
    }

    /// Update currently logged in user account name.
    models.User updateName(string name)
    {
        auto apiPath = "/account/name";

        JSONValue[string] apiParams;
        apiParams["name"] = serialize(name);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.User)(apiResponse.json);
    }

    /// Get the list of verified passkeys registered by the currently logged in user.
    models.PasskeyList listPasskeys(string[] queries = null, Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/account/passkeys";

        JSONValue[string] apiParams;
        if (queries !is null)
            apiParams["queries"] = serialize(queries);
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.PasskeyList)(apiResponse.json);
    }

    /// Start registering a passkey for the currently logged in user. The session must
    /// have signed in or completed an MFA challenge within the last 10 minutes. Pass
    /// the returned `publicKey` options to `navigator.credentials.create()`, then
    /// complete the registration with [Update passkey
    /// verification](/docs/references/cloud/client-web/account#updatePasskeyVerification).
    /// The passkey stays pending until verified, and the challenge expires after 5
    /// minutes.
    models.PasskeyChallenge createPasskey(string passkeyId = null, string name = null)
    {
        auto apiPath = "/account/passkeys";

        JSONValue[string] apiParams;
        if (passkeyId !is null)
            apiParams["passkeyId"] = serialize(passkeyId);
        if (name !is null)
            apiParams["name"] = serialize(name);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.PasskeyChallenge)(apiResponse.json);
    }

    /// Get a verified passkey of the currently logged in user by its unique ID.
    models.Passkey getPasskey(string passkeyId)
    {
        if (passkeyId.length == 0)
            throw new AppwriteException(`Missing required parameter: "passkeyId"`);
        auto apiPath = "/account/passkeys/{passkeyId}"
            .replace("{passkeyId}", encodeComponent(passkeyId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Passkey)(apiResponse.json);
    }

    /// Rename a passkey of the currently logged in user.
    models.Passkey updatePasskey(string passkeyId, string name)
    {
        if (passkeyId.length == 0)
            throw new AppwriteException(`Missing required parameter: "passkeyId"`);
        auto apiPath = "/account/passkeys/{passkeyId}"
            .replace("{passkeyId}", encodeComponent(passkeyId));

        JSONValue[string] apiParams;
        apiParams["name"] = serialize(name);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Passkey)(apiResponse.json);
    }

    /// Delete a passkey from the currently logged in user. The passkey can no longer be
    /// used to sign in, although it may remain stored on the user's device. The session
    /// must have signed in or completed an MFA challenge within the last 10 minutes.
    void deletePasskey(string passkeyId)
    {
        if (passkeyId.length == 0)
            throw new AppwriteException(`Missing required parameter: "passkeyId"`);
        auto apiPath = "/account/passkeys/{passkeyId}"
            .replace("{passkeyId}", encodeComponent(passkeyId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Complete a passkey registration started with [Create
    /// passkey](/docs/references/cloud/client-web/account#createPasskey). Pass the JSON
    /// form of the credential returned by `navigator.credentials.create()`, for example
    /// `credential.toJSON()`. Each registration can be verified once; a failed attempt
    /// requires starting it again.
    models.Passkey updatePasskeyVerification(string passkeyId, JSONValue credential)
    {
        if (passkeyId.length == 0)
            throw new AppwriteException(`Missing required parameter: "passkeyId"`);
        auto apiPath = "/account/passkeys/{passkeyId}/verification"
            .replace("{passkeyId}", encodeComponent(passkeyId));

        JSONValue[string] apiParams;
        apiParams["credential"] = serialize(credential);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Passkey)(apiResponse.json);
    }

    /// Update currently logged in user password. For validation, user is required to
    /// pass in the new password, and the old password. For users created with OAuth,
    /// Team Invites and Magic URL, oldPassword is optional.
    models.User updatePassword(string password, string oldPassword = null)
    {
        auto apiPath = "/account/password";

        JSONValue[string] apiParams;
        apiParams["password"] = serialize(password);
        if (oldPassword !is null)
            apiParams["oldPassword"] = serialize(oldPassword);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.User)(apiResponse.json);
    }

    /// Update the currently logged in user's phone number. After updating the phone
    /// number, the phone verification status will be reset. A confirmation SMS is not
    /// sent automatically, however you can use the [POST
    /// /account/verification/phone](https://appwrite.io/docs/references/cloud/client-web/account#createPhoneVerification)
    /// endpoint to send a confirmation SMS.
    models.User updatePhone(string phone, string password)
    {
        auto apiPath = "/account/phone";

        JSONValue[string] apiParams;
        apiParams["phone"] = serialize(phone);
        apiParams["password"] = serialize(password);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.User)(apiResponse.json);
    }

    /// Get the preferences as a key-value object for the currently logged in user.
    models.Preferences getPrefs()
    {
        auto apiPath = "/account/prefs";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Preferences)(apiResponse.json);
    }

    /// Update currently logged in user account preferences. The object you pass is
    /// stored as is, and replaces any previous value. The maximum allowed prefs size is
    /// 64kB and throws error if exceeded.
    models.User updatePrefs(JSONValue prefs)
    {
        auto apiPath = "/account/prefs";

        JSONValue[string] apiParams;
        apiParams["prefs"] = serialize(prefs);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.User)(apiResponse.json);
    }

    /// Sends the user an email with a temporary secret key for password reset. When the
    /// user clicks the confirmation link he is redirected back to your app password
    /// reset URL with the secret key and email address values attached to the URL query
    /// string. Use the query string params to submit a request to the [PUT
    /// /account/recovery](https://appwrite.io/docs/references/cloud/client-web/account#updateRecovery)
    /// endpoint to complete the process. The verification link sent to the user's email
    /// address is valid for 1 hour.
    models.Token createRecovery(string email, string url)
    {
        auto apiPath = "/account/recovery";

        JSONValue[string] apiParams;
        apiParams["email"] = serialize(email);
        apiParams["url"] = serialize(url);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Use this endpoint to complete the user account password reset. Both the
    /// **userId** and **secret** arguments will be passed as query parameters to the
    /// redirect URL you have provided when sending your request to the [POST
    /// /account/recovery](https://appwrite.io/docs/references/cloud/client-web/account#createRecovery)
    /// endpoint.
    ///
    /// Please note that in order to avoid a [Redirect
    /// Attack](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.md)
    /// the only valid redirect URLs are the ones from domains you have set when adding
    /// your platforms in the console interface.
    models.Token updateRecovery(string userId, string secret, string password)
    {
        auto apiPath = "/account/recovery";

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["secret"] = serialize(secret);
        apiParams["password"] = serialize(password);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Use this endpoint to send a 6-digit password recovery code to the user's email
    /// address. Unlike
    /// [createRecovery](https://appwrite.io/docs/references/cloud/client-web/account#createRecovery),
    /// this method requires no redirect URL, which makes it suitable for mobile and
    /// desktop apps that cannot host a recovery page. Learn more about how to [complete
    /// the recovery
    /// process](https://appwrite.io/docs/references/cloud/client-web/account#updateRecoveryOTP).
    /// The code sent to the user's email address is valid for 15 minutes.
    ///
    /// Enable the **phrase** parameter to include a randomly generated security phrase
    /// in both the email and the response. Showing that phrase in your app lets the
    /// user confirm the email genuinely came from your request, which helps protect
    /// against phishing.
    models.Token createRecoveryOTP(string email, Nullable!(bool) phrase = Nullable!(bool).init)
    {
        auto apiPath = "/account/recovery/otp";

        JSONValue[string] apiParams;
        apiParams["email"] = serialize(email);
        if (!phrase.isNull)
            apiParams["phrase"] = serialize(phrase);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Use this endpoint to complete the user password recovery process using the
    /// 6-digit code that was emailed by
    /// [createRecoveryOTP](https://appwrite.io/docs/references/cloud/client-web/account#createRecoveryOTP).
    /// Pass the **userId** of the user along with the **secret** code from the email
    /// and the new **password** to set. If confirmed, this route will return a 200
    /// status code, the code is consumed and the user's password is updated.
    models.Token updateRecoveryOTP(string userId, string secret, string password)
    {
        auto apiPath = "/account/recovery/otp";

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["secret"] = serialize(secret);
        apiParams["password"] = serialize(password);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Get the list of active sessions across different devices for the currently
    /// logged in user.
    models.SessionList listSessions(Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/account/sessions";

        JSONValue[string] apiParams;
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.SessionList)(apiResponse.json);
    }

    /// Delete all sessions from the user account and remove any sessions cookies from
    /// the end client. Pass `current` as false to keep the session making the request
    /// and sign out of every other session.
    void deleteSessions(Nullable!(bool) current = Nullable!(bool).init)
    {
        auto apiPath = "/account/sessions";

        JSONValue[string] apiParams;
        if (!current.isNull)
            apiParams["current"] = serialize(current);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Use this endpoint to allow a new user to register an anonymous account in your
    /// project. This route will also create a new session for the user. To allow the
    /// new user to convert an anonymous account to a normal account, you need to update
    /// its [email and
    /// password](https://appwrite.io/docs/references/cloud/client-web/account#updateEmail)
    /// or create an [OAuth2
    /// session](https://appwrite.io/docs/references/cloud/client-web/account#CreateOAuth2Session).
    models.Session createAnonymousSession()
    {
        auto apiPath = "/account/sessions/anonymous";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Session)(apiResponse.json);
    }

    /// Allow the user to login into their account by providing a valid email and
    /// password combination. This route will create a new session for the user. Use the
    /// optional `duration` parameter to create a shorter session, for example when the
    /// user doesn't choose "remember me". It must be at least 60 seconds and cannot
    /// exceed the project maximum session length.
    ///
    /// A user is limited to 10 active sessions at a time by default. [Learn more about
    /// session limits](https://appwrite.io/docs/authentication-security#limits).
    models.Session createEmailPasswordSession(string email, string password, long duration = unset!long)
    {
        auto apiPath = "/account/sessions/email";

        JSONValue[string] apiParams;
        apiParams["email"] = serialize(email);
        apiParams["password"] = serialize(password);
        if (isSet(duration))
            apiParams["duration"] = serialize(duration);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Session)(apiResponse.json);
    }

    /// Allow the user to login to their account using an OpenID Connect ID token
    /// obtained natively from the OAuth2 provider, for example via Google Credential
    /// Manager on Android or Sign in with Apple on iOS. No browser or redirect is
    /// involved: the ID token is verified against the provider's published signing keys
    /// and a session is created in a single request.
    ///
    /// Native sign-in is switched on per provider with its nativeEnabled setting. It is
    /// independent of the browser-based flow's enabled setting, which has no effect on
    /// this endpoint. The token's audience must match the provider's configured client
    /// ID or one of its native client IDs; tokens issued for any other client ID are
    /// rejected. For Sign in with Apple, register your app's bundle ID as a native
    /// client ID. For Google, the web client ID used by Credential Manager is usually
    /// the configured client ID; add your Android and iOS client IDs as native client
    /// IDs if your app requests tokens for them.
    ///
    /// Pass the raw nonce used when requesting the ID token so it can be validated
    /// against the token's nonce claim. When signing in with Apple, the nonce is
    /// required: hash it with SHA-256 before passing it to the Apple SDK, and send the
    /// raw value here - Apple tokens requested without a nonce are rejected. For Google
    /// the nonce is optional: it is validated whenever the token carries one, and
    /// ignored when the provider issued the token without one. Apple only returns the
    /// user's name on the first authorization, and never inside the ID token - capture
    /// it on the client and pass it via the name parameter.
    ///
    /// If there is already an active session, the new session will be attached to the
    /// logged-in account. If there are no active sessions, the server will attempt to
    /// look for a user with the same email address as the verified email received from
    /// the provider and attach the new session to the existing user. If no matching
    /// user is found - the server will create a new user.
    ///
    /// This flow does not return provider refresh tokens. You may pass an access token
    /// the provider handed your client, along with its lifetime, to store it on the
    /// session - but Appwrite cannot renew it once it expires. If your app needs
    /// long-lived access to provider APIs, use the browser-based OAuth2 flow instead.
    ///
    /// A user is limited to 10 active sessions at a time by default. [Learn more about
    /// session limits](https://appwrite.io/docs/authentication-security#limits).
    models.Session createIdTokenSession(enums.IdTokenProvider provider, string idToken, string nonce = null, string accessToken = null, long accessTokenExpiry = unset!long, string name = null)
    {
        auto apiPath = "/account/sessions/id-token";

        JSONValue[string] apiParams;
        apiParams["provider"] = serialize(provider);
        apiParams["idToken"] = serialize(idToken);
        if (nonce !is null)
            apiParams["nonce"] = serialize(nonce);
        if (accessToken !is null)
            apiParams["accessToken"] = serialize(accessToken);
        if (isSet(accessTokenExpiry))
            apiParams["accessTokenExpiry"] = serialize(accessTokenExpiry);
        if (name !is null)
            apiParams["name"] = serialize(name);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Session)(apiResponse.json);
    }

    /// Use this endpoint to create a session from token. Provide the **userId** and
    /// **secret** parameters from the successful response of authentication flows
    /// initiated by token creation. For example, magic URL and phone login.
    deprecated("This API has been deprecated since 1.6.0. Please use `account.createSession` instead.")
    models.Session updateMagicURLSession(string userId, string secret)
    {
        auto apiPath = "/account/sessions/magic-url";

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["secret"] = serialize(secret);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Session)(apiResponse.json);
    }

    /// Allow the user to login to their account using the OAuth2 provider of their
    /// choice. Each OAuth2 provider should be enabled from the Appwrite console first.
    /// Use the success and failure arguments to provide a redirect URL's back to your
    /// app when login is completed.
    ///
    /// If there is already an active session, the new session will be attached to the
    /// logged-in account. If there are no active sessions, the server will attempt to
    /// look for a user with the same email address as the email received from the
    /// OAuth2 provider and attach the new session to the existing user. If no matching
    /// user is found - the server will create a new user.
    ///
    /// A user is limited to 10 active sessions at a time by default. [Learn more about
    /// session limits](https://appwrite.io/docs/authentication-security#limits).
    string createOAuth2Session(enums.OAuthProvider provider, string success = null, string failure = null, string[] scopes = null, string state = null)
    {
        auto apiPath = "/account/sessions/oauth2/{provider}"
            .replace("{provider}", encodeComponent(cast(string) provider));

        JSONValue[string] apiParams;
        if (success !is null)
            apiParams["success"] = serialize(success);
        if (failure !is null)
            apiParams["failure"] = serialize(failure);
        if (scopes !is null)
            apiParams["scopes"] = serialize(scopes);
        if (state !is null)
            apiParams["state"] = serialize(state);
        apiParams["project"] = JSONValue(client.config("project"));

        return client.webAuth(client.endpoint ~ apiPath ~ "?" ~ buildQuery(apiParams));
    }

    /// Use this endpoint to create a session from token. Provide the **userId** and
    /// **secret** parameters from the successful response of authentication flows
    /// initiated by token creation. For example, magic URL and phone login.
    deprecated("This API has been deprecated since 1.6.0. Please use `account.createSession` instead.")
    models.Session updatePhoneSession(string userId, string secret)
    {
        auto apiPath = "/account/sessions/phone";

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["secret"] = serialize(secret);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Session)(apiResponse.json);
    }

    /// Use this endpoint to create a session from token. Provide the **userId** and
    /// **secret** parameters from the successful response of authentication flows
    /// initiated by token creation. For example, magic URL and phone login.
    models.Session createSession(string userId, string secret)
    {
        auto apiPath = "/account/sessions/token";

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["secret"] = serialize(secret);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Session)(apiResponse.json);
    }

    /// Use this endpoint to get a logged in user's session using a Session ID.
    /// Inputting 'current' will return the current session being used.
    models.Session getSession(string sessionId)
    {
        if (sessionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "sessionId"`);
        auto apiPath = "/account/sessions/{sessionId}"
            .replace("{sessionId}", encodeComponent(sessionId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Session)(apiResponse.json);
    }

    /// Use this endpoint to extend a session's length. Extending a session is useful
    /// when session expiry is short. If the session was created using an OAuth
    /// provider, this endpoint refreshes the access token from the provider.
    models.Session updateSession(string sessionId)
    {
        if (sessionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "sessionId"`);
        auto apiPath = "/account/sessions/{sessionId}"
            .replace("{sessionId}", encodeComponent(sessionId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Session)(apiResponse.json);
    }

    /// Logout the user. Use 'current' as the session ID to logout on this device, use a
    /// session ID to logout on another device. If you're looking to logout the user on
    /// all devices, use [Delete
    /// Sessions](https://appwrite.io/docs/references/cloud/client-web/account#deleteSessions)
    /// instead.
    void deleteSession(string sessionId)
    {
        if (sessionId.length == 0)
            throw new AppwriteException(`Missing required parameter: "sessionId"`);
        auto apiPath = "/account/sessions/{sessionId}"
            .replace("{sessionId}", encodeComponent(sessionId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Block the currently logged in user account. Behind the scene, the user record is
    /// not deleted but permanently blocked from any access. To completely delete a
    /// user, use the Users API instead.
    models.User updateStatus()
    {
        auto apiPath = "/account/status";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.patch, apiPath, apiHeaders, apiParams);
        return deserialize!(models.User)(apiResponse.json);
    }

    /// Use this endpoint to register a device for push notifications. Provide a target
    /// ID (custom or generated using ID.unique()), a device identifier (usually a
    /// device token), and optionally specify which provider should send notifications
    /// to this target. The target is automatically linked to the current session and
    /// includes device information like brand and model. A session holds one push
    /// target per provider, so if one already exists this endpoint updates and returns
    /// that target instead of creating a second one, and a device that rotates its
    /// token is never notified twice.
    models.Target createPushTarget(string targetId, string identifier, string providerId = null)
    {
        auto apiPath = "/account/targets/push";

        JSONValue[string] apiParams;
        apiParams["targetId"] = serialize(targetId);
        apiParams["identifier"] = serialize(identifier);
        if (providerId !is null)
            apiParams["providerId"] = serialize(providerId);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Target)(apiResponse.json);
    }

    /// Update the currently logged in user's push notification target. You can modify
    /// the target's identifier (device token) and provider ID (token, email, phone
    /// etc.). The target must exist and belong to the current user. If you change the
    /// provider ID, notifications will be sent through the new messaging provider
    /// instead.
    models.Target updatePushTarget(string targetId, string identifier)
    {
        if (targetId.length == 0)
            throw new AppwriteException(`Missing required parameter: "targetId"`);
        auto apiPath = "/account/targets/{targetId}/push"
            .replace("{targetId}", encodeComponent(targetId));

        JSONValue[string] apiParams;
        apiParams["identifier"] = serialize(identifier);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Target)(apiResponse.json);
    }

    /// Delete a push notification target for the currently logged in user. After
    /// deletion, the device will no longer receive push notifications. The target must
    /// exist and belong to the current user.
    void deletePushTarget(string targetId)
    {
        if (targetId.length == 0)
            throw new AppwriteException(`Missing required parameter: "targetId"`);
        auto apiPath = "/account/targets/{targetId}/push"
            .replace("{targetId}", encodeComponent(targetId));

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Sends the user an email with a secret key for creating a session. If the email
    /// address has never been used, a **new account is created** using the provided
    /// `userId`. Otherwise, if the email address is already attached to an account, the
    /// **user ID is ignored**. Then, the user will receive an email with the one-time
    /// password. Use the returned user ID and secret and submit a request to the [POST
    /// /v1/account/sessions/token](https://appwrite.io/docs/references/cloud/client-web/account#createSession)
    /// endpoint to complete the login process. The secret sent to the user's email is
    /// valid for 15 minutes.
    ///
    /// A user is limited to 10 active sessions at a time by default. [Learn more about
    /// session limits](https://appwrite.io/docs/authentication-security#limits).
    models.Token createEmailToken(string userId, string email, Nullable!(bool) phrase = Nullable!(bool).init)
    {
        auto apiPath = "/account/tokens/email";

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["email"] = serialize(email);
        if (!phrase.isNull)
            apiParams["phrase"] = serialize(phrase);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Sends the user an email with a secret key for creating a session. If the
    /// provided user ID has not been registered, a new user will be created. When the
    /// user clicks the link in the email, the user is redirected back to the URL you
    /// provided with the secret key and userId values attached to the URL query string.
    /// Use the query string parameters to submit a request to the [POST
    /// /v1/account/sessions/token](https://appwrite.io/docs/references/cloud/client-web/account#createSession)
    /// endpoint to complete the login process. The link sent to the user's email
    /// address is valid for 1 hour.
    ///
    /// A user is limited to 10 active sessions at a time by default. [Learn more about
    /// session limits](https://appwrite.io/docs/authentication-security#limits).
    models.Token createMagicURLToken(string userId, string email, string url = null, Nullable!(bool) phrase = Nullable!(bool).init)
    {
        auto apiPath = "/account/tokens/magic-url";

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["email"] = serialize(email);
        if (url !is null)
            apiParams["url"] = serialize(url);
        if (!phrase.isNull)
            apiParams["phrase"] = serialize(phrase);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Allow the user to login to their account using the OAuth2 provider of their
    /// choice. Each OAuth2 provider should be enabled from the Appwrite console first.
    /// Use the success and failure arguments to provide a redirect URL's back to your
    /// app when login is completed.
    ///
    /// If authentication succeeds, `userId` and `secret` of a token will be appended to
    /// the success URL as query parameters. These can be used to create a new session
    /// using the [Create
    /// session](https://appwrite.io/docs/references/cloud/client-web/account#createSession)
    /// endpoint.
    ///
    /// If there is already an active session, the OAuth2 identity is attached to the
    /// logged-in account and that session stays active until the token is exchanged for
    /// a new one.
    ///
    /// A user is limited to 10 active sessions at a time by default. [Learn more about
    /// session limits](https://appwrite.io/docs/authentication-security#limits).
    string createOAuth2Token(enums.OAuthProvider provider, string success = null, string failure = null, string[] scopes = null, string state = null)
    {
        auto apiPath = "/account/tokens/oauth2/{provider}"
            .replace("{provider}", encodeComponent(cast(string) provider));

        JSONValue[string] apiParams;
        if (success !is null)
            apiParams["success"] = serialize(success);
        if (failure !is null)
            apiParams["failure"] = serialize(failure);
        if (scopes !is null)
            apiParams["scopes"] = serialize(scopes);
        if (state !is null)
            apiParams["state"] = serialize(state);
        apiParams["project"] = JSONValue(client.config("project"));

        return client.webAuth(client.endpoint ~ apiPath ~ "?" ~ buildQuery(apiParams));
    }

    /// Start signing in with a passkey. No email or user ID is needed: pass the
    /// returned `publicKey` options to `navigator.credentials.get()` and the user picks
    /// one of their passkeys. Then call [Update passkey
    /// token](/docs/references/cloud/client-web/account#updatePasskeyToken) with the
    /// credential to receive a token, and exchange it with [Create
    /// session](/docs/references/cloud/client-web/account#createSession). The challenge
    /// expires after 5 minutes.
    models.PasskeyChallenge createPasskeyToken()
    {
        auto apiPath = "/account/tokens/passkey";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.PasskeyChallenge)(apiResponse.json);
    }

    /// Complete a passkey sign-in started with [Create passkey
    /// token](/docs/references/cloud/client-web/account#createPasskeyToken). Pass the
    /// challenge ID and the JSON form of the credential returned by
    /// `navigator.credentials.get()`, for example `credential.toJSON()`. The returned
    /// token includes its secret and expires after 1 minute: exchange it for a session
    /// with [Create session](/docs/references/cloud/client-web/account#createSession).
    /// Passkeys require user verification, so the session also satisfies MFA. Each
    /// challenge can only be used once.
    models.TokenSecret updatePasskeyToken(string challengeId, JSONValue credential)
    {
        auto apiPath = "/account/tokens/passkey";

        JSONValue[string] apiParams;
        apiParams["challengeId"] = serialize(challengeId);
        apiParams["credential"] = serialize(credential);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.TokenSecret)(apiResponse.json);
    }

    /// Sends the user an SMS with a secret key for creating a session. If the provided
    /// user ID has not be registered, a new user will be created. Use the returned user
    /// ID and secret and submit a request to the [POST
    /// /v1/account/sessions/token](https://appwrite.io/docs/references/cloud/client-web/account#createSession)
    /// endpoint to complete the login process. The secret sent to the user's phone is
    /// valid for 15 minutes.
    ///
    /// A user is limited to 10 active sessions at a time by default. [Learn more about
    /// session limits](https://appwrite.io/docs/authentication-security#limits).
    models.Token createPhoneToken(string userId, string phone)
    {
        auto apiPath = "/account/tokens/phone";

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["phone"] = serialize(phone);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Use this endpoint to send a verification message to your user email address to
    /// confirm they are the valid owners of that address. Both the **userId** and
    /// **secret** arguments will be passed as query parameters to the URL you have
    /// provided to be attached to the verification email. The provided URL should
    /// redirect the user back to your app and allow you to complete the verification
    /// process by verifying both the **userId** and **secret** parameters. Learn more
    /// about how to [complete the verification
    /// process](https://appwrite.io/docs/references/cloud/client-web/account#updateVerification).
    /// The verification link sent to the user's email address is valid for 7 days.
    ///
    /// Please note that in order to avoid a [Redirect
    /// Attack](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.md),
    /// the only valid redirect URLs are the ones from domains you have set when adding
    /// your platforms in the console interface.
    models.Token createEmailVerification(string url)
    {
        auto apiPath = "/account/verifications/email";

        JSONValue[string] apiParams;
        apiParams["url"] = serialize(url);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Use this endpoint to send a verification message to your user email address to
    /// confirm they are the valid owners of that address. Both the **userId** and
    /// **secret** arguments will be passed as query parameters to the URL you have
    /// provided to be attached to the verification email. The provided URL should
    /// redirect the user back to your app and allow you to complete the verification
    /// process by verifying both the **userId** and **secret** parameters. Learn more
    /// about how to [complete the verification
    /// process](https://appwrite.io/docs/references/cloud/client-web/account#updateVerification).
    /// The verification link sent to the user's email address is valid for 7 days.
    ///
    /// Please note that in order to avoid a [Redirect
    /// Attack](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.md),
    /// the only valid redirect URLs are the ones from domains you have set when adding
    /// your platforms in the console interface.
    deprecated("This API has been deprecated since 1.8.0. Please use `account.createEmailVerification` instead.")
    models.Token createVerification(string url)
    {
        auto apiPath = "/account/verifications/email";

        JSONValue[string] apiParams;
        apiParams["url"] = serialize(url);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Use this endpoint to complete the user email verification process. Use both the
    /// **userId** and **secret** parameters that were attached to your app URL to
    /// verify the user email ownership. If confirmed this route will return a 200
    /// status code.
    models.Token updateEmailVerification(string userId, string secret)
    {
        auto apiPath = "/account/verifications/email";

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["secret"] = serialize(secret);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Use this endpoint to complete the user email verification process. Use both the
    /// **userId** and **secret** parameters that were attached to your app URL to
    /// verify the user email ownership. If confirmed this route will return a 200
    /// status code.
    deprecated("This API has been deprecated since 1.8.0. Please use `account.updateEmailVerification` instead.")
    models.Token updateVerification(string userId, string secret)
    {
        auto apiPath = "/account/verifications/email";

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["secret"] = serialize(secret);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Use this endpoint to send a 6-digit verification code to the currently logged in
    /// user's email address. Unlike
    /// [createEmailVerification](https://appwrite.io/docs/references/cloud/client-web/account#createEmailVerification),
    /// this method requires no redirect URL, which makes it suitable for mobile and
    /// desktop apps that cannot host a verification page. Learn more about how to
    /// [complete the verification
    /// process](https://appwrite.io/docs/references/cloud/client-web/account#updateEmailVerificationOTP).
    /// The code sent to the user's email address is valid for 15 minutes.
    ///
    /// Enable the **phrase** parameter to include a randomly generated security phrase
    /// in both the email and the response. Showing that phrase in your app lets the
    /// user confirm the email genuinely came from your request, which helps protect
    /// against phishing.
    models.Token createEmailVerificationOTP(Nullable!(bool) phrase = Nullable!(bool).init)
    {
        auto apiPath = "/account/verifications/email/otp";

        JSONValue[string] apiParams;
        if (!phrase.isNull)
            apiParams["phrase"] = serialize(phrase);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Use this endpoint to complete the user email verification process using the
    /// 6-digit code that was emailed by
    /// [createEmailVerificationOTP](https://appwrite.io/docs/references/cloud/client-web/account#createEmailVerificationOTP).
    /// Pass the **userId** of the user being verified along with the **secret** code
    /// from the email. If confirmed, this route will return a 200 status code and the
    /// code is consumed.
    models.Token updateEmailVerificationOTP(string userId, string secret)
    {
        auto apiPath = "/account/verifications/email/otp";

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["secret"] = serialize(secret);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Use this endpoint to send a verification SMS to the currently logged in user.
    /// This endpoint is meant for use after updating a user's phone number using the
    /// [accountUpdatePhone](https://appwrite.io/docs/references/cloud/client-web/account#updatePhone)
    /// endpoint. Learn more about how to [complete the verification
    /// process](https://appwrite.io/docs/references/cloud/client-web/account#updatePhoneVerification).
    /// The verification code sent to the user's phone number is valid for 15 minutes.
    models.Token createPhoneVerification()
    {
        auto apiPath = "/account/verifications/phone";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.post, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }

    /// Use this endpoint to complete the user phone verification process. Use the
    /// **userId** and **secret** that were sent to your user's phone number to verify
    /// the user email ownership. If confirmed this route will return a 200 status code.
    models.Token updatePhoneVerification(string userId, string secret)
    {
        auto apiPath = "/account/verifications/phone";

        JSONValue[string] apiParams;
        apiParams["userId"] = serialize(userId);
        apiParams["secret"] = serialize(secret);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.put, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Token)(apiResponse.json);
    }
}
