#!/bin/sh
# End-to-end test of the D SDK against the appwrite/sdk-generator mock server.
#
# Needs Docker (for the mock server, and for PHP 8.5 when it is not installed)
# and a D toolchain with dub (LDC or DMD). Run generator/composer install first.
#
#   tests/e2e/run.sh            start the mock server, test, stop it
#   KEEP_MOCK=1 tests/e2e/run.sh  leave the mock server running afterwards
set -e
here="$(cd "$(dirname "$0")" && pwd)"
root="$(cd "$here/../.." && pwd)"
mock="$root/generator/vendor/appwrite/sdk-generator/mock-server"
php="$root/generator/php"

if ! curl -s --noproxy '*' -o /dev/null "http://localhost:8080/v1/mock/tests/foo"; then
    echo "Starting the mock server"
    if ! docker image inspect appwrited-mockapi >/dev/null 2>&1; then
        (cd "$mock" && composer install --ignore-platform-reqs --no-dev --no-plugins --no-scripts --prefer-dist -q)
        docker build -q -t appwrited-mockapi -f "$here/mock.Dockerfile" "$mock"
    fi
    docker rm -f appwrited-mockapi >/dev/null 2>&1 || true
    docker run -d --name appwrited-mockapi -p 8080:80 appwrited-mockapi >/dev/null
    started=1
    for i in $(seq 1 30); do
        curl -s --noproxy '*' -o /dev/null "http://localhost:8080/v1/mock/tests/foo" && break
        sleep 1
    done
fi

cleanup() {
    if [ -n "$started" ] && [ -z "$KEEP_MOCK" ]; then
        docker rm -f appwrited-mockapi >/dev/null 2>&1 || true
    fi
}
trap cleanup EXIT

(cd "$here" && "$php" run.php generate)
(cd "$here/test" && dub build -q)
(cd "$here/test" && MOCK_RESOURCES="$root/generator/vendor/appwrite/sdk-generator/tests/resources" ./e2e) > "$here/output.txt"
(cd "$here" && "$php" run.php compare output.txt)
