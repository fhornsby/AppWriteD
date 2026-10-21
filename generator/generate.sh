#!/bin/sh
# Regenerate the D SDK into the repository root.
#
#   ./generate.sh                         API version from config.json
#   ./generate.sh --spec-version=2.4.x    another Appwrite API version
#   ./generate.sh --spec-file=spec.json   a local OpenAPI 3 document
#   ./generate.sh --version=0.2.0         SDK version (default from config.json)
#
# Needs `composer install` first, and PHP 8.5 or Docker (see ./php).
set -e
cd "$(dirname "$0")"
exec ./php generate.php "$@"
