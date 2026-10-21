module appwrite.enums.authentication_factor;

/// AuthenticationFactor
enum AuthenticationFactor : string
{
    email = "email",
    phone = "phone",
    totp = "totp",
    recoverycode = "recoverycode",
    custom = "custom",
}
