#!/bin/bash
set -o nounset
aquamacs "$2"
sleep 0.5
osascript -e "
tell application \"AquaMacs\"
  activate
  tell application \"System Events\"
    keystroke \"l\" using command down
    keystroke \"$1\"
    key code 36
  end tell
end tell" > /dev/null 2>&1
