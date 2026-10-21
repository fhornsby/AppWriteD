/**
 * JSON mapping for models.
 *
 * Models are plain structs. Fields map to JSON keys of the same name unless
 * they carry a `@jsonKey("...")` attribute, and a `JSONValue` field marked
 * `@jsonExtra` receives the whole object, so attributes the SDK does not know
 * about (your own collection columns, for instance) are never lost.
 *
 * Deserialization is lenient: a missing key keeps the field's default, a
 * `null` clears a `Nullable`, numbers convert between integer and floating
 * point, and an enum value the SDK does not know is kept as-is.
 */
module appwrite.json;

import std.conv : to, ConvException;
import std.json;
import std.traits;
import std.typecons : Nullable;

/// Names the JSON key a field maps to, e.g. `@jsonKey("$id") string id;`.
struct jsonKey
{
    string name;
}

/// Marks a `JSONValue` field that receives the entire JSON object.
enum jsonExtra;

/// The JSON key for field `i` of `T`.
template jsonKeyOf(T, size_t i)
{
    alias keys = getUDAs!(T.tupleof[i], jsonKey);
    static if (keys.length)
        enum jsonKeyOf = keys[0].name;
    else
        enum jsonKeyOf = __traits(identifier, T.tupleof[i]);
}

private enum isExtraField(T, size_t i) = hasUDA!(T.tupleof[i], jsonExtra);

/**
 * Default of an optional number parameter, meaning "not given": the parameter
 * is left out of the request. `long.min` for integers, NaN for floating point.
 */
template unset(T) if (isNumeric!T)
{
    static if (isFloatingPoint!T)
        enum T unset = T.nan;
    else
        enum T unset = T.min;
}

/// Whether an optional number parameter was given (is not `unset!T`).
bool isSet(T)(T value) if (isNumeric!T)
{
    static if (isFloatingPoint!T)
    {
        import std.math : isNaN;

        return !isNaN(value);
    }
    else
        return value != T.min;
}

/**
 * An empty array that is not `null`. Optional array parameters are left out
 * of the request when null, and `[]` is null in D, so pass this to send an
 * explicitly empty list, e.g. `permissions: emptyList!string` to clear them.
 */
T[] emptyList(T)()
{
    return (new T[1])[0 .. 0];
}

unittest
{
    assert(!isSet(unset!long));
    assert(isSet(0L));
    assert(!isSet(unset!double));
    assert(isSet(0.5));
    assert(emptyList!string !is null && emptyList!string.length == 0);
}

/// Convert a JSON value to `T`.
T deserialize(T)(JSONValue json)
{
    static if (is(T == JSONValue))
    {
        return json;
    }
    else static if (is(T : Nullable!U, U))
    {
        if (json.isNull)
            return T.init;
        return T(deserialize!U(json));
    }
    else static if (is(T == enum))
    {
        static assert(is(OriginalType!T == string), "only string enums are supported");
        if (json.type == JSONType.string)
            return cast(T) json.str;
        if (json.isNull)
            return cast(T) null;
        return cast(T) json.toString();
    }
    else static if (isSomeString!T)
    {
        switch (json.type)
        {
        case JSONType.string:
            return json.str.to!T;
        case JSONType.null_:
            return null;
        default:
            return json.toString().to!T;
        }
    }
    else static if (is(T == bool))
    {
        switch (json.type)
        {
        case JSONType.true_:
            return true;
        case JSONType.false_:
            return false;
        case JSONType.integer:
            return json.integer != 0;
        case JSONType.uinteger:
            return json.uinteger != 0;
        case JSONType.string:
            return json.str == "true" || json.str == "1";
        default:
            return false;
        }
    }
    else static if (isIntegral!T)
    {
        switch (json.type)
        {
        case JSONType.integer:
            return cast(T) json.integer;
        case JSONType.uinteger:
            return cast(T) json.uinteger;
        case JSONType.float_:
            return cast(T) json.floating;
        case JSONType.true_:
            return 1;
        case JSONType.string:
            try
                return json.str.to!T;
            catch (ConvException)
                return T.init;
        default:
            return T.init;
        }
    }
    else static if (isFloatingPoint!T)
    {
        switch (json.type)
        {
        case JSONType.integer:
            return cast(T) json.integer;
        case JSONType.uinteger:
            return cast(T) json.uinteger;
        case JSONType.float_:
            return cast(T) json.floating;
        case JSONType.string:
            try
                return json.str.to!T;
            catch (ConvException)
                return T.init;
        default:
            return T.init;
        }
    }
    else static if (is(T == E[], E))
    {
        if (json.type == JSONType.array)
        {
            T result;
            result.reserve(json.array.length);
            foreach (item; json.array)
                result ~= deserialize!E(item);
            return result;
        }
        if (json.isNull)
            return null;
        return [deserialize!E(json)];
    }
    else static if (is(T == V[string], V))
    {
        T result;
        if (json.type == JSONType.object)
            foreach (key, item; json.object)
                result[key] = deserialize!V(item);
        return result;
    }
    else static if (is(T == struct))
    {
        T result;
        if (json.type != JSONType.object)
            return result;
        static foreach (i; 0 .. T.tupleof.length)
        {
            static if (isExtraField!(T, i))
            {
                result.tupleof[i] = json;
            }
            else
            {
                if (auto value = jsonKeyOf!(T, i) in json)
                    result.tupleof[i] = deserialize!(typeof(T.tupleof[i]))(*value);
            }
        }
        return result;
    }
    else
    {
        static assert(false, "cannot deserialize " ~ T.stringof);
    }
}

/// Parse `text` and convert it to `T`.
T deserialize(T)(string text)
{
    return deserialize!T(parseJSON(text));
}

/// Convert a value to JSON.
JSONValue serialize(T)(T value)
{
    static if (is(T == JSONValue))
    {
        return value;
    }
    else static if (is(T == typeof(null)))
    {
        return JSONValue(null);
    }
    else static if (is(T : Nullable!U, U))
    {
        return value.isNull ? JSONValue(null) : serialize(value.get);
    }
    else static if (is(T == enum))
    {
        auto raw = cast(OriginalType!T) value;
        return raw is null ? JSONValue(null) : JSONValue(raw);
    }
    else static if (isSomeString!T)
    {
        return JSONValue(value.to!string);
    }
    else static if (is(T == bool) || isIntegral!T || isFloatingPoint!T)
    {
        return JSONValue(value);
    }
    else static if (is(T == E[], E))
    {
        JSONValue[] items;
        items.reserve(value.length);
        foreach (item; value)
            items ~= serialize(item);
        return JSONValue(items);
    }
    else static if (is(T == V[string], V))
    {
        JSONValue[string] items;
        foreach (key, item; value)
            items[key] = serialize(item);
        return JSONValue(items);
    }
    else static if (is(T == class))
    {
        if (value is null)
            return JSONValue(null);
        return value.toJson();
    }
    else static if (is(T == struct))
    {
        JSONValue[string] fields;
        static foreach (i; 0 .. T.tupleof.length)
        {
            static if (isExtraField!(T, i))
            {
                if (value.tupleof[i].type == JSONType.object)
                    foreach (key, item; value.tupleof[i].object)
                        if (key !in fields)
                            fields[key] = item;
            }
        }
        static foreach (i; 0 .. T.tupleof.length)
        {
            static if (!isExtraField!(T, i))
                fields[jsonKeyOf!(T, i)] = serialize(value.tupleof[i]);
        }
        return JSONValue(fields);
    }
    else
    {
        static assert(false, "cannot serialize " ~ T.stringof);
    }
}

/**
 * Write JSON compactly: numbers in their shortest round-trip form (`0.1`, not
 * `0.100000000000000006`), `/` left unescaped, object keys sorted.
 */
string toJSONString(JSONValue value)
{
    import std.array : appender;

    auto output = appender!string;
    writeJSON(output, value);
    return output.data;
}

private void writeJSON(Output)(ref Output output, JSONValue value)
{
    import std.algorithm : sort;

    final switch (value.type)
    {
    case JSONType.null_:
        output.put("null");
        break;
    case JSONType.true_:
        output.put("true");
        break;
    case JSONType.false_:
        output.put("false");
        break;
    case JSONType.integer:
        output.put(value.integer.to!string);
        break;
    case JSONType.uinteger:
        output.put(value.uinteger.to!string);
        break;
    case JSONType.float_:
        output.put(formatNumber(value.floating));
        break;
    case JSONType.string:
        writeString(output, value.str);
        break;
    case JSONType.array:
        output.put('[');
        foreach (i, item; value.array)
        {
            if (i)
                output.put(',');
            writeJSON(output, item);
        }
        output.put(']');
        break;
    case JSONType.object:
        output.put('{');
        auto object = value.object;
        foreach (i, key; object.keys.sort.release)
        {
            if (i)
                output.put(',');
            writeString(output, key);
            output.put(':');
            writeJSON(output, object[key]);
        }
        output.put('}');
        break;
    }
}

private void writeString(Output)(ref Output output, string text)
{
    import std.format : formattedWrite;

    output.put('"');
    foreach (char c; text)
    {
        switch (c)
        {
        case '"':
            output.put(`\"`);
            break;
        case '\\':
            output.put(`\\`);
            break;
        case '\n':
            output.put(`\n`);
            break;
        case '\r':
            output.put(`\r`);
            break;
        case '\t':
            output.put(`\t`);
            break;
        case '\b':
            output.put(`\b`);
            break;
        case '\f':
            output.put(`\f`);
            break;
        default:
            if (c < 0x20)
                output.formattedWrite!"\\u%04x"(c);
            else
                output.put(c);
        }
    }
    output.put('"');
}

/// The shortest decimal text that reads back as exactly `value`. NaN and infinity become `null`.
string formatNumber(double value)
{
    import std.format : format;
    import std.math : isFinite, abs, floor;

    if (!isFinite(value))
        return "null";
    if (value == floor(value) && abs(value) < 1e15)
        return format("%.0f", value);
    foreach (precision; 1 .. 18)
    {
        auto text = format("%.*g", precision, value);
        if (text.to!double == value)
            return text;
    }
    return format("%.17g", value);
}

unittest
{
    assert(formatNumber(40.7128) == "40.7128");
    assert(formatNumber(-74.0) == "-74");
    assert(formatNumber(0.1) == "0.1");
    assert(formatNumber(1e21) == "1e+21");
    assert(toJSONString(JSONValue(["b": JSONValue("x/y"), "a": JSONValue([1.5, 2.0])])) == `{"a":[1.5,2],"b":"x/y"}`);
}

unittest
{
    import std.typecons : nullable;

    enum Color : string
    {
        red = "red",
        blue = "blue",
    }

    static struct Inner
    {
        long count = 25;
    }

    static struct Model
    {
        @jsonKey("$id") string id;
        double score;
        Nullable!bool flag;
        Color color;
        Color[] palette;
        Inner inner;
        Nullable!Inner maybe;
        string[] tags;
        @jsonExtra JSONValue data;
    }

    auto model = deserialize!Model(`{"$id":"a","score":3,"flag":null,"color":"green",` ~
        `"palette":["red"],"inner":{},"tags":["x"],"custom":1}`);
    assert(model.id == "a");
    assert(model.score == 3.0);
    assert(model.flag.isNull);
    assert(model.color == "green");
    assert(model.palette == [Color.red]);
    assert(model.inner.count == 25);
    assert(model.maybe.isNull);
    assert(model.tags == ["x"]);
    assert(model.data["custom"].integer == 1);

    model.flag = true.nullable;
    auto json = serialize(model);
    assert(json["$id"].str == "a");
    assert(json["flag"].boolean);
    assert(json["custom"].integer == 1);
    assert(json["maybe"].isNull);
    assert(deserialize!Model(json).id == "a");
}

