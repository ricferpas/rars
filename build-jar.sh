#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
SCRIPT_COMMAND="$0"
set -o nounset
set -o pipefail
set -o errexit
trap 'echo "$SCRIPT_COMMAND: error $? at line $LINENO"' ERR

cd "$SCRIPT_DIR"

if ! git submodule status | grep \( > /dev/null ; then # TODO: improve this test
    echo "It looks like JSoftFloat is not cloned. Consider running \"git submodule update --init\""
    exit 1
fi

#version=$(git describe --tags --match 'v*' --dirty | cut -c2-)
version=$(git describe --dirty --always --tags)
echo "Version = $version" > src/Version.properties

TMPDIR="$(mktemp -d)"
JAVAC_OPTS=(
    #-Xlint:deprecation
    #-Xlint:unchecked
    --release 11
)

find src -name "*.java" | xargs javac "${JAVAC_OPTS[@]}" -d "$TMPDIR"

(
    # Include everything in src/ but .java files in the JAR (TODO: improve to avoid including unnecessary files)
    cd src
    if [[ "$OSTYPE" == "darwin"* ]]; then
        find . -type f -not -name "*.java" -exec rsync -R {} "$TMPDIR" \;
    else
        find . -type f -not -name "*.java" -exec cp --parents {} "$TMPDIR" \;
    fi
)

cp README.md LICENSE "$TMPDIR"
cd "$TMPDIR"
jar cfm "${SCRIPT_DIR}/rars.jar" ./META-INF/MANIFEST.MF *
chmod +x "${SCRIPT_DIR}/rars.jar"
rm -rf "$TMPDIR"

