module appwrite.models.locale;

import std.json : JSONType, JSONValue;
import std.typecons : Nullable;

import appwrite.json;
import enums = appwrite.enums;
import models = appwrite.models;

/// Locale
struct Locale
{
    /// User IP address.
    @jsonKey("ip") string ip;

    /// Country code in [ISO 3166-1](http://en.wikipedia.org/wiki/ISO_3166-1)
    /// two-character format
    @jsonKey("countryCode") string countryCode;

    /// Country name. This field support localization.
    @jsonKey("country") string country;

    /// Continent code. A two character continent code "AF" for Africa, "AN" for
    /// Antarctica, "AS" for Asia, "EU" for Europe, "NA" for North America, "OC" for
    /// Oceania, and "SA" for South America.
    @jsonKey("continentCode") string continentCode;

    /// Continent name. This field support localization.
    @jsonKey("continent") string continent;

    /// True if country is part of the European Union.
    @jsonKey("eu") bool eu = false;

    /// Currency code in [ISO 4217-1](http://en.wikipedia.org/wiki/ISO_4217)
    /// three-character format
    @jsonKey("currency") string currency;

    /// City
    @jsonKey("city") string city;

    /// Name of timezone
    @jsonKey("timeZone") string timeZone;

    /// Postal code
    @jsonKey("postalCode") string postalCode;

    /// Latitude
    @jsonKey("latitude") Nullable!(double) latitude;

    /// Longitude
    @jsonKey("longitude") Nullable!(double) longitude;

    /// Autonomous System Number (ASN) of the IP
    @jsonKey("autonomousSystemNumber") string autonomousSystemNumber;

    /// Organization that owns the ASN
    @jsonKey("autonomousSystemOrganization") string autonomousSystemOrganization;

    /// Internet service provider of the IP
    @jsonKey("isp") string isp;

    /// Connection type of the IP (e.g. cable, cellular, corporate)
    @jsonKey("connectionType") string connectionType;

    /// User type classification of the IP (e.g. residential, business, hosting)
    @jsonKey("connectionUsageType") string connectionUsageType;

    /// Registered organization of the IP
    @jsonKey("connectionOrganization") string connectionOrganization;

    /// Parse a `Locale` from JSON.
    static Locale fromJson(JSONValue json)
    {
        return deserialize!(Locale)(json);
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
