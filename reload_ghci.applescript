#!/usr/bin/env osascript
tell application "Terminal" to activate

tell application "System Events"
	keystroke ":"
	keystroke "r"
	keystroke "\n"
end tell

tell application "TextMate" to activate