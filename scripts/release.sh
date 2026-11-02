#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE="${VFLOW_SOURCE_DIR:?Set VFLOW_SOURCE_DIR to the private small-models-stt-pipeline checkout}"
PUBLISH=false
case "${1:-}" in
  '') ;;
  --publish) PUBLISH=true ;;
  *) echo 'Usage: release.sh [--publish]' >&2; exit 1 ;;
esac
if "$PUBLISH"; then
  : "${VFLOW_RELEASE_REPO:?Set VFLOW_RELEASE_REPO to owner/repository}"
  : "${VFLOW_RELEASE_NOTES:?Set VFLOW_RELEASE_NOTES to a reviewed release-notes file}"
  [[ -f "$VFLOW_RELEASE_NOTES" ]] || { echo 'Release notes file not found.' >&2; exit 1; }
  command -v gh >/dev/null
  gh auth status
fi
# Run on a normal Apple silicon Mac with Xcode and cached model weights.
swift test --package-path "$SOURCE/native"
bash "$SOURCE/scripts/build-native.sh"
bash "$SOURCE/scripts/package-dmg.sh"
VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$SOURCE/dist/Vflow.app/Contents/Info.plist")"
NAME="Vflow-$VERSION-arm64.dmg"
mkdir -p "$ROOT/artifacts"
cp "$SOURCE/dist/$NAME" "$ROOT/artifacts/$NAME"
(cd "$ROOT/artifacts" && shasum -a 256 "$NAME" > "$NAME.sha256")
if "$PUBLISH"; then
  gh release create "v$VERSION" "$ROOT/artifacts/$NAME" "$ROOT/artifacts/$NAME.sha256" \
    --repo "$VFLOW_RELEASE_REPO" --title "Vflow $VERSION" --notes-file "$VFLOW_RELEASE_NOTES" --prerelease
else
  echo "Ready for review: $ROOT/artifacts/$NAME"
fi
