#!/usr/bin/env osascript

tell application "Safari"
	do JavaScript "window.location.reload();" in first document
end tell

