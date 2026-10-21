module appwrite.services.locale;

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

/// The Locale service allows you to customize your app based on your users'
/// location.
class Locale : Service
{
    this(Client client)
    {
        super(client);
    }

    /// Get the current user location based on IP. Returns an object with user country
    /// code, country name, continent name, continent code, ip address and suggested
    /// currency. You can use the locale header to get the data in a supported language.
    ///
    /// ([IP Geolocation by DB-IP](https://db-ip.com))
    models.Locale get()
    {
        auto apiPath = "/locale";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.Locale)(apiResponse.json);
    }

    /// List of all locale codes in [ISO
    /// 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes).
    models.LocaleCodeList listCodes(Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/locale/codes";

        JSONValue[string] apiParams;
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.LocaleCodeList)(apiResponse.json);
    }

    /// List of all continents. You can use the locale header to get the data in a
    /// supported language.
    models.ContinentList listContinents(Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/locale/continents";

        JSONValue[string] apiParams;
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.ContinentList)(apiResponse.json);
    }

    /// List of all countries. You can use the locale header to get the data in a
    /// supported language.
    models.CountryList listCountries(Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/locale/countries";

        JSONValue[string] apiParams;
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.CountryList)(apiResponse.json);
    }

    /// List of all countries that are currently members of the EU. You can use the
    /// locale header to get the data in a supported language.
    models.CountryList listCountriesEU(Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/locale/countries/eu";

        JSONValue[string] apiParams;
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.CountryList)(apiResponse.json);
    }

    /// List of all countries phone codes. You can use the locale header to get the data
    /// in a supported language.
    models.PhoneList listCountriesPhones(Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/locale/countries/phones";

        JSONValue[string] apiParams;
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.PhoneList)(apiResponse.json);
    }

    /// List of all currencies, including currency symbol, name, plural, and decimal
    /// digits for all major and minor currencies. You can use the locale header to get
    /// the data in a supported language.
    models.CurrencyList listCurrencies(Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/locale/currencies";

        JSONValue[string] apiParams;
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.CurrencyList)(apiResponse.json);
    }

    /// List of all languages classified by ISO 639-1 including 2-letter code, name in
    /// English, and name in the respective language.
    models.LanguageList listLanguages(Nullable!(bool) total = Nullable!(bool).init)
    {
        auto apiPath = "/locale/languages";

        JSONValue[string] apiParams;
        if (!total.isNull)
            apiParams["total"] = serialize(total);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams);
        return deserialize!(models.LanguageList)(apiResponse.json);
    }
}
