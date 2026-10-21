module appwrite.services.avatars;

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

/// The Avatars service aims to help you complete everyday tasks related to your app
/// image, icons, and avatars.
class Avatars : Service
{
    this(Client client)
    {
        super(client);
    }

    /// You can use this endpoint to show different browser icons to your users. The
    /// code argument receives the browser code as it appears in your user [GET
    /// /account/sessions](https://appwrite.io/docs/references/cloud/client-web/account#getSessions)
    /// endpoint. Use width, height and quality arguments to change the output settings.
    ///
    /// When one dimension is specified and the other is 0, the image is scaled with
    /// preserved aspect ratio. If both dimensions are 0, the API provides an image at
    /// source quality. If dimensions are not specified, the default size of image
    /// returned is 100x100px.
    ubyte[] getBrowser(enums.Browser code, long width = unset!long, long height = unset!long, long quality = unset!long)
    {
        auto apiPath = "/avatars/browsers/{code}"
            .replace("{code}", encodeComponent(cast(string) code));

        JSONValue[string] apiParams;
        if (isSet(width))
            apiParams["width"] = serialize(width);
        if (isSet(height))
            apiParams["height"] = serialize(height);
        if (isSet(quality))
            apiParams["quality"] = serialize(quality);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "image/png";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams, ResponseType.bytes);
        return apiResponse.bytes;
    }

    /// The credit card endpoint will return you the icon of the credit card provider
    /// you need. Use width, height and quality arguments to change the output settings.
    ///
    /// When one dimension is specified and the other is 0, the image is scaled with
    /// preserved aspect ratio. If both dimensions are 0, the API provides an image at
    /// source quality. If dimensions are not specified, the default size of image
    /// returned is 100x100px.
    ubyte[] getCreditCard(enums.CreditCard code, long width = unset!long, long height = unset!long, long quality = unset!long)
    {
        auto apiPath = "/avatars/credit-cards/{code}"
            .replace("{code}", encodeComponent(cast(string) code));

        JSONValue[string] apiParams;
        if (isSet(width))
            apiParams["width"] = serialize(width);
        if (isSet(height))
            apiParams["height"] = serialize(height);
        if (isSet(quality))
            apiParams["quality"] = serialize(quality);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "image/png";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams, ResponseType.bytes);
        return apiResponse.bytes;
    }

    /// Use this endpoint to fetch the favorite icon (AKA favicon) of any remote website
    /// URL.
    ///
    /// This endpoint does not follow HTTP redirects.
    ubyte[] getFavicon(string url)
    {
        auto apiPath = "/avatars/favicon";

        JSONValue[string] apiParams;
        apiParams["url"] = serialize(url);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "image/*";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams, ResponseType.bytes);
        return apiResponse.bytes;
    }

    /// You can use this endpoint to show different country flags icons to your users.
    /// The code argument receives the 2 letter country code. Use width, height and
    /// quality arguments to change the output settings. Country codes follow the [ISO
    /// 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) standard.
    ///
    /// When one dimension is specified and the other is 0, the image is scaled with
    /// preserved aspect ratio. If both dimensions are 0, the API provides an image at
    /// source quality. If dimensions are not specified, the default size of image
    /// returned is 100x100px.
    ubyte[] getFlag(enums.Flag code, long width = unset!long, long height = unset!long, long quality = unset!long)
    {
        auto apiPath = "/avatars/flags/{code}"
            .replace("{code}", encodeComponent(cast(string) code));

        JSONValue[string] apiParams;
        if (isSet(width))
            apiParams["width"] = serialize(width);
        if (isSet(height))
            apiParams["height"] = serialize(height);
        if (isSet(quality))
            apiParams["quality"] = serialize(quality);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "image/png";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams, ResponseType.bytes);
        return apiResponse.bytes;
    }

    /// Use this endpoint to fetch a remote image URL and crop it to any image size you
    /// want. This endpoint is very useful if you need to crop and display remote images
    /// in your app or in case you want to make sure a 3rd party image is properly
    /// served using a TLS protocol.
    ///
    /// When one dimension is specified and the other is 0, the image is scaled with
    /// preserved aspect ratio. If both dimensions are 0, the API provides an image at
    /// source quality. If dimensions are not specified, the default size of image
    /// returned is 400x400px.
    ///
    /// This endpoint does not follow HTTP redirects.
    ubyte[] getImage(string url, long width = unset!long, long height = unset!long)
    {
        auto apiPath = "/avatars/image";

        JSONValue[string] apiParams;
        apiParams["url"] = serialize(url);
        if (isSet(width))
            apiParams["width"] = serialize(width);
        if (isSet(height))
            apiParams["height"] = serialize(height);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "image/*";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams, ResponseType.bytes);
        return apiResponse.bytes;
    }

    /// Use this endpoint to show your user initials avatar icon on your website or app.
    /// By default, this route will try to print your logged-in user name or email
    /// initials. You can also overwrite the user name if you pass the 'name' parameter.
    /// If no name is given and no user is logged, an empty avatar will be returned.
    ///
    /// You can use the color and background params to change the avatar colors. By
    /// default, a random theme will be selected. The random theme will persist for the
    /// user's initials when reloading the same theme will always return for the same
    /// initials.
    ///
    /// When one dimension is specified and the other is 0, the image is scaled with
    /// preserved aspect ratio. If both dimensions are 0, the API provides an image at
    /// source quality. If dimensions are not specified, the default size of image
    /// returned is 100x100px.
    ubyte[] getInitials(string name = null, long width = unset!long, long height = unset!long, string background = null)
    {
        auto apiPath = "/avatars/initials";

        JSONValue[string] apiParams;
        if (name !is null)
            apiParams["name"] = serialize(name);
        if (isSet(width))
            apiParams["width"] = serialize(width);
        if (isSet(height))
            apiParams["height"] = serialize(height);
        if (background !is null)
            apiParams["background"] = serialize(background);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "image/png";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams, ResponseType.bytes);
        return apiResponse.bytes;
    }

    /// Returns the best available profile photo for a user. The endpoint tries each
    /// source in priority order and returns the first successful result: a custom
    /// uploaded photo (see avatars.updatePhoto), OAuth2 identity photo, Gravatar,
    /// Libravatar, Appwrite Initials, built-in static fallback.
    ///
    /// Passing `userId` — `current()` for the authenticated user — resolves the
    /// photo from everything known about that user: identity photos, email, and name.
    /// An explicit `emailHash` or `name` then overrides just that value, and the user's
    /// remaining sources stay in the chain. Without `userId`, passing `emailHash`
    /// and/or `name` resolves the avatar from those values alone: the hash is looked up
    /// on Gravatar and Libravatar, the name is rendered as initials, and the session
    /// user stays out of the chain so their own photo never shadows the avatar being
    /// asked for. When nothing is passed, the photo resolves for the currently
    /// authenticated user. Emails are only ever accepted pre-hashed, so no address ends
    /// up in a URL.
    ubyte[] getPhoto(long width = unset!long, long height = unset!long, long quality = unset!long, string output = null, string rating = null, string userId = null, string emailHash = null, string name = null)
    {
        auto apiPath = "/avatars/photo";

        JSONValue[string] apiParams;
        if (isSet(width))
            apiParams["width"] = serialize(width);
        if (isSet(height))
            apiParams["height"] = serialize(height);
        if (isSet(quality))
            apiParams["quality"] = serialize(quality);
        if (output !is null)
            apiParams["output"] = serialize(output);
        if (rating !is null)
            apiParams["rating"] = serialize(rating);
        if (userId !is null)
            apiParams["userId"] = serialize(userId);
        if (emailHash !is null)
            apiParams["emailHash"] = serialize(emailHash);
        if (name !is null)
            apiParams["name"] = serialize(name);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "image/*";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams, ResponseType.bytes);
        return apiResponse.bytes;
    }

    /// Update the profile photo of the currently authenticated user. The uploaded image
    /// takes priority over every other photo source, including OAuth2 identity photos,
    /// Gravatar, and Libravatar. Updating an already customized photo replaces it. The
    /// image must be at most 5MB and is sent in a single request.
    models.Account updatePhoto(InputFile file, UploadProgressCallback onProgress = null)
    {
        auto apiPath = "/avatars/photo";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "multipart/form-data";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.chunkedUpload(HttpMethod.put, apiPath, apiHeaders, apiParams,
            "file", "", file, onProgress);
        return deserialize!(models.Account)(apiResponse.json);
    }

    /// Delete the profile photo of the currently authenticated user and store the
    /// built-in static placeholder in its place. The placeholder is the user's photo
    /// from then on, so it takes priority over every other photo source — OAuth2
    /// identity photos, Gravatar, Libravatar, and initials — until a new photo is
    /// uploaded with avatars.updatePhoto.
    void deletePhoto()
    {
        auto apiPath = "/avatars/photo";

        JSONValue[string] apiParams;

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["content-type"] = "application/json";
        apiHeaders["accept"] = "application/json";

        auto apiResponse = client.call(HttpMethod.delete_, apiPath, apiHeaders, apiParams);
        cast(void) apiResponse;
    }

    /// Converts a given plain text to a QR code image. You can use the query parameters
    /// to change the size and style of the resulting image.
    ubyte[] getQR(string text, long size = unset!long, long margin = unset!long, Nullable!(bool) download = Nullable!(bool).init)
    {
        auto apiPath = "/avatars/qr";

        JSONValue[string] apiParams;
        apiParams["text"] = serialize(text);
        if (isSet(size))
            apiParams["size"] = serialize(size);
        if (isSet(margin))
            apiParams["margin"] = serialize(margin);
        if (!download.isNull)
            apiParams["download"] = serialize(download);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "image/png";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams, ResponseType.bytes);
        return apiResponse.bytes;
    }

    /// Use this endpoint to capture a screenshot of any website URL. This endpoint uses
    /// a headless browser to render the webpage and capture it as an image.
    ///
    /// You can configure the browser viewport size, theme, user agent, geolocation,
    /// permissions, and more. Capture either just the viewport or the full page scroll.
    ///
    /// When width and height are specified, the image is resized accordingly. If both
    /// dimensions are 0, the API provides an image at original size. If dimensions are
    /// not specified, the default viewport size is 1280x720px.
    ubyte[] getScreenshot(string url, JSONValue headers = JSONValue.init, long viewportWidth = unset!long, long viewportHeight = unset!long, double scale = unset!double, enums.BrowserTheme theme = cast(enums.BrowserTheme) null, string userAgent = null, Nullable!(bool) fullpage = Nullable!(bool).init, string locale = null, enums.Timezone timezone = cast(enums.Timezone) null, double latitude = unset!double, double longitude = unset!double, double accuracy = unset!double, Nullable!(bool) touch = Nullable!(bool).init, enums.BrowserPermission[] permissions = null, long sleep = unset!long, long width = unset!long, long height = unset!long, long quality = unset!long, enums.ImageFormat output = cast(enums.ImageFormat) null)
    {
        auto apiPath = "/avatars/screenshots";

        JSONValue[string] apiParams;
        apiParams["url"] = serialize(url);
        if (headers.type != JSONType.null_)
            apiParams["headers"] = serialize(headers);
        if (isSet(viewportWidth))
            apiParams["viewportWidth"] = serialize(viewportWidth);
        if (isSet(viewportHeight))
            apiParams["viewportHeight"] = serialize(viewportHeight);
        if (isSet(scale))
            apiParams["scale"] = serialize(scale);
        if (theme !is null)
            apiParams["theme"] = serialize(theme);
        if (userAgent !is null)
            apiParams["userAgent"] = serialize(userAgent);
        if (!fullpage.isNull)
            apiParams["fullpage"] = serialize(fullpage);
        if (locale !is null)
            apiParams["locale"] = serialize(locale);
        if (timezone !is null)
            apiParams["timezone"] = serialize(timezone);
        if (isSet(latitude))
            apiParams["latitude"] = serialize(latitude);
        if (isSet(longitude))
            apiParams["longitude"] = serialize(longitude);
        if (isSet(accuracy))
            apiParams["accuracy"] = serialize(accuracy);
        if (!touch.isNull)
            apiParams["touch"] = serialize(touch);
        if (permissions !is null)
            apiParams["permissions"] = serialize(permissions);
        if (isSet(sleep))
            apiParams["sleep"] = serialize(sleep);
        if (isSet(width))
            apiParams["width"] = serialize(width);
        if (isSet(height))
            apiParams["height"] = serialize(height);
        if (isSet(quality))
            apiParams["quality"] = serialize(quality);
        if (output !is null)
            apiParams["output"] = serialize(output);

        string[string] apiHeaders;
        apiHeaders["X-Appwrite-Project"] = client.config("project");
        apiHeaders["accept"] = "image/png";

        auto apiResponse = client.call(HttpMethod.get, apiPath, apiHeaders, apiParams, ResponseType.bytes);
        return apiResponse.bytes;
    }
}
