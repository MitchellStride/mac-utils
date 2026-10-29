# mac-utils

Small personal macOS utilities, starting with **Function Keys**.

## Function Keys
A menu bar app that displays **Fn** when the top row controls brightness and volume, or **F1** when standard function keys are enabled. Click its menu to switch modes. Holding Fn temporarily uses the other mode. Quitting the app leaves the selected setting in place.

### Install and start at login
1. Unzip `Function-Keys-Apple-Silicon.zip` and move **Function Keys.app** to Applications.
2. Open the app. Look for **Fn** or **F1** in the menu bar.
3. To start it automatically, add it in **System Settings → General → Login Items & Extensions → Open at Login**.

This is an ad-hoc signed personal utility, not an Apple-notarized release. A downloaded copy may require approval under **System Settings → Privacy & Security** after the first opening attempt. Only approve a build whose source you trust.

### Compatibility and verification
The build script produces an Apple Silicon app with a macOS 13 minimum deployment target. This is a build target, not a claim that every supported macOS release or keyboard has been tested.

The toggle changes `com.apple.keyboard.fnState` and invokes Apple's undocumented `activateSettings -u` helper. Apple may change this behavior. External keyboards may have their own Fn-lock behavior.

Local compilation and signature checks pass, and the installed app launches successfully. Actual keyboard switching and cross-Mac compatibility remain unverified. Initial tagged releases are marked prerelease for this reason.

### Build from source
Install Apple's Xcode Command Line Tools, then run:

```sh
zsh build.sh
```

Outputs are placed in `build/`, including the app and a ZIP for sharing. Source is in `FunctionKeys/FunctionKeys.swift`; bundle metadata is in `FunctionKeys/Info.plist`.

### GitHub automation
Pushes to `main` and pull requests build the app and upload a downloadable build artifact. Pushing a version tag such as `v0.1.0` also creates a GitHub prerelease with the ZIP attached. The workflow can be started manually from Actions.

### Manual verification before a stable release
- Open the app and verify that its indicator matches System Settings.
- Toggle in both directions and verify the top-row keys actually change behavior.
- Change the setting in System Settings and verify the indicator updates.
- Quit and reopen; confirm the setting persists.
- Test opening a downloaded ZIP on another Mac before claiming distribution compatibility.

## Optional script
`toggle-function-keys.sh` performs the same toggle without the menu bar app. It can be run from a Run Shell Script action in Apple's Shortcuts app with a keyboard shortcut.

## Screenshot shortcut
In **System Settings → Keyboard → Keyboard Shortcuts → Screenshots**, change **Copy picture of selected area to the clipboard** to **Command-Shift-S**. This is configured separately from the app.
