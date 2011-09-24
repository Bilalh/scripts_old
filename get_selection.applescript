#!/usr/bin/env osascript
set res to ""
tell application "Finder"
	set paths to the selection
	repeat with i from 1 to number of items in paths
		set res to res & "	" & quoted form of POSIX path of (item i of paths as alias)
	end repeat
end tell
res