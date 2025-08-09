#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
SCRIPT_COMMAND="$0"
set -o nounset
set -o pipefail
set -o errexit
trap 'echo "$SCRIPT_COMMAND: error $? at line $LINENO"' ERR

cd "$SCRIPT_DIR"

flatlaf_jar="flatlaf-3.2.jar"

if [ ! -f "$flatlaf_jar" ]; then
    curl https://repo1.maven.org/maven2/com/formdev/flatlaf/3.2/flatlaf-3.2.jar -o "$flatlaf_jar"
fi

TMPDIR="$(mktemp -d)"
cd "$TMPDIR"

jar x < "${SCRIPT_DIR}/rars.jar"
jar x < "${SCRIPT_DIR}/${flatlaf_jar}"

cat > META-INF/MANIFEST.MF <<EOF
Manifest-Version: 1.0
Implementation-Version: 3.1.1
Multi-Release: true
Main-Class: rars.Launch
EOF

jar cfm "${SCRIPT_DIR}/rars-flatlaf.jar" META-INF/MANIFEST.MF *
chmod +x "${SCRIPT_DIR}/rars-flatlaf.jar"
rm -rf "$TMPDIR"
