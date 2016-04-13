#!/usr/bin/env osascript
set old to (path to frontmost application as text)

tell application "System Events"
	tell application "iTerm" to activate
	delay 1
	keystroke "k" using command down
	keystroke ":"
	keystroke "r"
	keystroke "
"
	delay 2
	keystroke "r" using {command down, control down, option down}
end tell
delay 0.5
activate application old
