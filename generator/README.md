# D target for the Appwrite SDK generator

This directory turns the official Appwrite API specification into the D client
SDK at the repository root. It plugs a D language target into
[appwrite/sdk-generator](https://github.com/appwrite/sdk-generator), the tool
Appwrite builds its own Flutter, Web, Swift, Kotlin and other SDKs with, so the
D SDK follows the same API surface and naming as those SDKs.

## Layout

| Path | Purpose |
|------|---------|
| `src/D.php` | The language definition: type mapping, keywords, file list, D-specific Twig filters |
| `src/SDK.php` | Subclass of the upstream `SDK` that adds `templates/` to the Twig search path, so no fork of the generator is needed |
| `templates/d/` | Twig templates for every generated file; `source/appwrite/*.d.twig` are the hand-written runtime parts (HTTP client, JSON mapping, cookies, realtime, async) |
| `generate.php` | Loads the spec, generates into a scratch directory, then replaces only the generated paths in the repository root |
| `config.json` | Package name, SDK version, default Appwrite API version, metadata |
| `php` | Runs PHP 8.5: the local `php` when new enough, otherwise the `php:8.5-cli` Docker image |
| `generate.sh` | `./php generate.php`, with the options below |

The upstream generator is pinned to a commit in `composer.json`; bump it to
pick up generator fixes and new spec features.

## Regenerating

```sh
composer install                        # once; any PHP works with --ignore-platform-reqs
./generate.sh                           # Appwrite API version from config.json
./generate.sh --spec-version=2.4.x      # a different Appwrite release
./generate.sh --spec-commit=main        # latest specs, not the commit pinned in config.json
./generate.sh --spec-file=my-spec.json  # a local OpenAPI 3 document
./generate.sh --version=0.2.0           # set the SDK version
```

Specs are fetched from https://github.com/appwrite/specs at the commit pinned
in `config.json` (`specCommit`), so regenerating is reproducible; bump it to
pick up spec fixes. Pick the version that
matches your server: Appwrite Cloud runs the latest, self-hosted servers report
theirs in the console footer. The generated client sends
`X-Appwrite-Response-Format` for that version, so an SDK generated for an older
API keeps working against a newer server.

`generate.php` only replaces the paths it owns: `source/appwrite`,
`docs/examples`, `examples`, `dub.json`, `README.md`, `CHANGELOG.md`,
`LICENSE` and `.gitignore`. Edit the templates, never the generated output.

## Testing

```sh
cd .. && dub test                       # unit tests in the runtime modules
tests/e2e/run.sh                        # end-to-end, against the upstream mock server
tests/integration/run.sh                # integration, against a real Appwrite server
```

The end-to-end suite generates the SDK from the generator's own test fixture,
builds `tests/e2e/test` against it and runs it against the mock API server that
ships with appwrite/sdk-generator (in Docker). Its output is compared with the
expectations the upstream suite holds every SDK to, read directly from
`vendor/appwrite/sdk-generator/tests/e2e/Base.php`: HTTP methods, path, query
and multipart encoding, chunked uploads, downloads, model defaults, errors,
cookies, every Query/Permission/Role/ID/Channel/Operator helper, and the
realtime protocol (subscribe, query filters, errors, unsubscribe, update,
presence, disconnect).

The integration suite starts a real Appwrite server (API, realtime, worker,
MariaDB and Redis) with Docker Compose, creates a project with a table and a
bucket through the console API, and runs `tests/integration` as an end user:
sign-up and sign-in, session cookies persisted and reused by a new client, JWTs,
preferences, rows with queries and row-level permissions, realtime create,
update and delete events over an authenticated socket, a 12 MB chunked upload
downloaded back intact, avatars, locale, `async` with a dispatcher, error
mapping and sign-out.

All three suites run in GitHub Actions (`.github/workflows/ci.yml`); unit tests
run on Linux, macOS and Windows.

## Design notes

- **Client platform.** The spec is filtered to the `client` platform, so only
  endpoints an end user may call are generated, and authentication is by
  session cookie, JWT or session secret rather than API key.
- **No dependencies.** HTTP goes through Phobos' `std.net.curl`. Realtime needs
  a WebSocket, which Phobos lacks, so `appwrite.websocket` implements RFC 6455
  over a libcurl "connect only" connection (`appwrite.curl` loads libcurl at
  run time like `std.net.curl` does). TLS, proxies and certificates therefore
  behave the same for API calls and realtime, with any libcurl version.
- **Optional parameters** are named arguments with defaults: `null` for strings,
  arrays, enums and files; `unset!long` / `unset!double` for numbers, so a call
  reads `width: 256`; `Nullable!bool` for booleans. (A template-typed optional
  would avoid `Nullable`, but current D frontends reject skipping one with
  named arguments.)
- **Models** are structs mapped to JSON by compile-time reflection in
  `appwrite.json`; `@jsonKey` renames fields (`$id` becomes `id`), and models
  with user-defined attributes (rows, documents, preferences) keep the whole
  object in `data` with `opIndex` and `convertTo!T` helpers.
- **Namespacing** follows the Flutter SDK: `import appwrite;` brings in the
  services and helpers, with models under `models.` and enums under `enums.`,
  which keeps model `Locale` apart from service `Locale`.
- **Sessions** use a cookie jar (with Appwrite's `X-Fallback-Cookies` as a
  backup) that a `CookieStore` can persist. OAuth2 uses the RFC 8252 loopback
  flow the Flutter SDK uses on Windows and Linux.
- **Threads.** Everything blocks; `appwrite.async` runs calls on a worker and
  hands results to a `Dispatcher`, which a UI drains on its own thread.
