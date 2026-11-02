#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="${VFLOW_APP_PATH:?Set VFLOW_APP_PATH to the built Vflow.app}"
[[ -d "$APP" ]] || { echo 'Run ./scripts/build-native.sh first.' >&2; exit 1; }
VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$APP/Contents/Info.plist")"
mkdir -p "$ROOT/artifacts"
OUTPUT="$ROOT/artifacts/Vflow-$VERSION-arm64.dmg"
STAGE="$(mktemp -d "${TMPDIR:-/tmp}/vflow-dmg.XXXXXX")"
trap 'rm -rf "$STAGE"' EXIT
mkdir "$STAGE/payload"
ditto "$APP" "$STAGE/payload/Vflow.app"
codesign --force --deep --sign - "$STAGE/payload/Vflow.app"
codesign --verify --deep --strict "$STAGE/payload/Vflow.app"
ln -s /Applications "$STAGE/payload/Applications"
cat > "$STAGE/payload/READ ME.txt" <<'EOF'
Vflow for Apple silicon — macOS 14 or later

Drag Vflow into Applications, then open it from Applications.

This beta is ad-hoc signed and has not been notarized by Apple.
If macOS blocks opening it, try System Settings > Privacy & Security >
Open Anyway after attempting to launch the app.

If you trust this download, you can alternatively run this in Terminal:
  xattr -dr com.apple.quarantine "/Applications/Vflow.app"

Then open Vflow and grant Microphone, Accessibility, and Input Monitoring
permissions when requested.
EOF
hdiutil create -volname "Vflow $VERSION" -srcfolder "$STAGE/payload" \
    -format UDZO -ov "$STAGE/Vflow.dmg"
hdiutil verify "$STAGE/Vflow.dmg"
mv -f "$STAGE/Vflow.dmg" "$OUTPUT"
(cd "$(dirname "$OUTPUT")" && shasum -a 256 "$(basename "$OUTPUT")" > "$(basename "$OUTPUT").sha256")
echo "Packaged: $OUTPUT"
