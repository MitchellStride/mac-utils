#!/bin/zsh
set -euo pipefail
cd "${0:A:h}"
app="$PWD/build/Function Keys.app"
mkdir -p "$app/Contents/MacOS" "$PWD/build/module-cache"
mkdir -p "$app/Contents/Resources"
cp FunctionKeys/AppIcon.icns "$app/Contents/Resources/AppIcon.icns"
cp FunctionKeys/Info.plist "$app/Contents/Info.plist"
xcrun swiftc -O -target arm64-apple-macos13.0 -module-cache-path "$PWD/build/module-cache" FunctionKeys/FunctionKeys.swift -o "$app/Contents/MacOS/FunctionKeys"
codesign --force --sign - "$app"
codesign --verify --strict "$app"
plutil -lint "$app/Contents/Info.plist"
ditto -c -k --sequesterRsrc --keepParent "$app" "$PWD/build/Function-Keys-Apple-Silicon.zip"
echo "Built: $app"
