#!/bin/zsh
set -e
current=$(/usr/bin/defaults read -g com.apple.keyboard.fnState 2>/dev/null || echo 0)
if [[ "$current" == "1" ]]; then
  next=false
else
  next=true
fi
/usr/bin/defaults write -g com.apple.keyboard.fnState -bool "$next"
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
