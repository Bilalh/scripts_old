#!/usr/bin/env osascript
tell application "iTermFloating"
	activate
	delay 0.2
	tell i term application "System Events" to keystroke "¤" using control down
end tell