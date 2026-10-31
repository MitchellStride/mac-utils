# mac-utils

Small utilities for Apple Silicon Macs.

## Function Keys

A lightweight menu bar app for switching between standard **F1–F12** keys and **brightness, volume, and media controls**. The menu bar shows **F1** or **Fn** to reflect the current mode.

Built with Swift and AppKit. Targets macOS 13 and later.

[Releases](https://github.com/MitchellStride/mac-utils/releases)

## Build

Requires Xcode Command Line Tools.

```sh
zsh build.sh
```

Creates the app and a distributable ZIP in `build/`.

For a script-only toggle, run `zsh toggle-function-keys.sh`.
