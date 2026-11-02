# Vflow

Offline dictation for your Mac. Hold Fn, speak, and release to put the text where you’re writing.

Speech recognition and text cleanup run entirely on your device. Models ship with the app, so dictation needs no internet connection, API key, or cloud service.

**Apple silicon · macOS 14 or later · approximately 800–950 MB RAM in the maintainer’s usage**

Memory use varies with your Mac, recording length, and processing. This range is an approximate observation, not a guaranteed limit.

## Download

Get the latest DMG from this repository’s **Releases** page. This repository hosts Vflow downloads, release notes, and release tooling. Application source is maintained separately.

1. Open the DMG and drag **Vflow** into **Applications**.
2. Open Vflow from Applications.
3. Allow Microphone, Accessibility, and Input Monitoring access when prompted.

This beta is ad-hoc signed and is not notarized by Apple. If macOS blocks it, attempt to open it, then go to **System Settings → Privacy & Security → Open Anyway**.

You can also remove quarantine from this app in Terminal:

```sh
xattr -dr com.apple.quarantine "/Applications/Vflow.app"
```

Then open Vflow again. The command applies only to the installed Vflow app.

## What it does

- **Dictate into other apps.** Hold Fn to record and release to finish. Text stays on the clipboard if insertion cannot be confirmed or focus changes.
- **Record hands-free.** Toggle recording with Fn+Option or Fn+Space. Press Esc to cancel.
- **Clean up speech locally.** Moonshine Base transcribes speech; S1-mini by Superwhisper handles text cleanup on your Mac.
- **Keep your spellings.** Add preferred words and corrections to a personal dictionary. Import and export dictionary entries as JSON.
- **Review past dictations.** Browse local history and copy earlier text. History can be disabled or cleared.
- **See recording status.** A floating indicator shows listening, processing, and delivery status without taking keyboard focus.
- **Track usage.** The menu-bar dashboard shows daily words and estimated time saved.

Ctrl+Option is the fallback hold shortcut; add Space for hands-free recording. If Fn opens the emoji picker, set the Fn/Globe action to **Do Nothing** in macOS Keyboard settings. Recordings are limited to 60 seconds. Vflow currently uses the system’s default microphone.

## Your data

Audio is processed locally and held in a temporary file during a session, then removed when the session completes or is cancelled. When history is enabled, final text and metadata are stored locally. Dictionary entries also stay on your Mac.

Vflow’s recognition and cleanup models are bundled in the download. Internet access is needed to download the app, but not to use dictation.

## Project and credits

Vflow is a native SwiftUI and AppKit macOS app, developed as part of the **small-models-stt-pipeline** project. It uses Moonshine Base for speech recognition and Superwhisper’s S1-mini through MLX Swift for local cleanup.

- [Moonshine](https://github.com/moonshine-ai/moonshine)
- [S1-mini by Superwhisper](https://huggingface.co/superwhisper/s1-mini)
- [MLX Swift](https://github.com/ml-explore/mlx-swift)

Third-party components and model weights retain their respective licenses. This repository does not grant a license to the Vflow application or its source.

## Releases

Each release contains an Apple silicon DMG and a SHA-256 checksum. See [RELEASING.md](RELEASING.md) for the build and publication pipeline.
