#!/bin/sh
# Integration test against a real Appwrite server in Docker.
#
# Starts Appwrite (see docker-compose.yml), creates a console user, a project,
# an API key, database `main` with table `todos`, and bucket `files`, then runs
# the D program in source/app.d as an end user of that project.
#
#   tests/integration/run.sh                 start, test, tear down
#   KEEP_SERVER=1 tests/integration/run.sh   leave the server running
#
# Image names can be overridden with APPWRITE_IMAGE, MARIADB_IMAGE, REDIS_IMAGE;
# ports with APPWRITE_PORT (9080) and APPWRITE_REALTIME_PORT (9081).
set -e
here="$(cd "$(dirname "$0")" && pwd)"
port="${APPWRITE_PORT:-9080}"
endpoint="http://localhost:$port/v1"
compose="docker compose -p appwrited-it -f $here/docker-compose.yml"
jar="$(mktemp)"

cleanup() {
    rm -f "$jar"
    if [ -z "$KEEP_SERVER" ]; then
        $compose down -v >/dev/null 2>&1 || true
    fi
}
trap cleanup EXIT

echo "Starting Appwrite"
$compose up -d --quiet-pull
for i in $(seq 1 120); do
    if curl -sf --noproxy '*' "$endpoint/health/version" >/dev/null 2>&1; then
        break
    fi
    sleep 2
done
curl -sf --noproxy '*' "$endpoint/health/version"
echo

console() { # method path [json]
    curl -sf --noproxy '*' -b "$jar" -c "$jar" -X "$1" "$endpoint$2" \
        -H "Content-Type: application/json" -H "X-Appwrite-Project: console" ${3:+-d "$3"}
}

# The API answers /health before it has finished initialising, so each setup
# step is retried until it succeeds.
retry() { # function
    for attempt in $(seq 1 30); do
        if "$1"; then
            return 0
        fi
        sleep 2
    done
    echo "Setup step $1 kept failing" >&2
    return 1
}

sign_in() {
    console POST /account '{"userId":"admin","email":"admin@example.com","password":"integration-admin-1","name":"Admin"}' >/dev/null 2>&1 || true
    console POST /account/sessions/email '{"email":"admin@example.com","password":"integration-admin-1"}' >/dev/null
}

create_project() {
    console POST /teams '{"teamId":"org","name":"Org"}' >/dev/null 2>&1 || true
    console POST /projects '{"projectId":"dtest","name":"D test","teamId":"org","region":"default"}' >/dev/null 2>&1 \
        || console GET /projects/dtest >/dev/null
}

create_key() {
    key="$(console POST /projects/dtest/keys '{"keyId":"'"setup$(date +%s)"'","name":"setup","scopes":["databases.read","databases.write","tables.read","tables.write","columns.read","columns.write","buckets.read","buckets.write"]}' \
        | sed -n 's/.*"secret":"\([^"]*\)".*/\1/p')"
    [ -n "$key" ]
}

echo "Creating the test project"
retry sign_in
retry create_project
retry create_key

server() { # method path json
    curl -sf --noproxy '*' -X "$1" "$endpoint$2" -H "Content-Type: application/json" \
        -H "X-Appwrite-Project: dtest" -H "X-Appwrite-Key: $key" ${3:+-d "$3"}
}
server POST /tablesdb '{"databaseId":"main","name":"Main"}' >/dev/null || true
server POST /tablesdb/main/tables '{"tableId":"todos","name":"Todos","permissions":["create(\"users\")"],"rowSecurity":true}' >/dev/null || true
server POST /tablesdb/main/tables/todos/columns/string '{"key":"title","size":255,"required":true}' >/dev/null || true
server POST /tablesdb/main/tables/todos/columns/boolean '{"key":"done","required":false,"default":false}' >/dev/null || true
server POST /storage/buckets '{"bucketId":"files","name":"Files","permissions":["create(\"users\")"],"fileSecurity":true}' >/dev/null || true
for i in $(seq 1 60); do
    if [ "$(server GET /tablesdb/main/tables/todos/columns | grep -o '"status":"available"' | wc -l)" -ge 2 ]; then
        break
    fi
    sleep 1
done

echo "Running the integration test"
cd "$here"
dub build -q
APPWRITE_ENDPOINT="$endpoint" APPWRITE_REALTIME_ENDPOINT="ws://localhost:${APPWRITE_REALTIME_PORT:-9081}/v1" \
    APPWRITE_PROJECT=dtest ./integration
