# Releasing Vflow

Build on an Apple silicon Mac with full Xcode 16.3 or later, its Metal toolchain, and the model weights required by the private source checkout. The build needs internet access to resolve dependencies; the shipped app runs offline.

## Build pipeline

```sh
export VFLOW_SOURCE_DIR=/absolute/path/to/small-models-stt-pipeline
./scripts/release.sh
```

The pipeline runs native core tests, builds the app and bundled models, packages an ad-hoc signed DMG, verifies the app signature and disk image, and writes the DMG and checksum into the ignored `artifacts/` directory. The private source checkout must contain `scripts/build-native.sh` and `scripts/package-dmg.sh`.

Open the DMG and test installation, permissions, recording, cleanup, cancellation, clipboard delivery, and offline use on another Mac before publication. Confirm model and dependency redistribution licenses and include required notices with the release. Check RAM usage on the release build before changing the published estimate.

## Publish a reviewed beta

Create an empty public GitHub repository and push this folder’s Git repository to it. Keep application source and model weights out of its Git history. Install GitHub CLI and sign in with `gh auth login`.

Write release notes describing changes and known issues, then run:

```sh
export VFLOW_RELEASE_REPO=YOUR_ACCOUNT/vflow-releases
export VFLOW_RELEASE_NOTES=/absolute/path/to/release-notes.md
./scripts/release.sh --publish
```

This rebuilds and publishes a prerelease with the DMG and checksum. An existing version tag causes publication to fail rather than replacing its assets. Increment the application version in the private checkout for each new release.

Users can verify the download by putting both assets in the same directory and running:

```sh
shasum -a 256 -c Vflow-0.7.0-arm64.dmg.sha256
```

## Repository setup

```sh
 git remote add origin https://github.com/YOUR_ACCOUNT/vflow-releases.git
 git push -u origin main
```

The public GitHub Actions workflow checks shell syntax. Builds and publication run locally because they require private source, model weights, and a full macOS environment. No private repository credentials are needed in public CI. GitHub also generates source archives of this public release repository; these contain documentation and tooling only.

README copy follows the plain, product-specific guidance in [unslop by Damir Sokolovsky (@heydamir)](https://github.com/heydamir/unslop), licensed CC BY 4.0.
