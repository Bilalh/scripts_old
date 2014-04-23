#!/usr/bin/osascript
tell application "iTunes"
	set songLocations to get location of selection
	
	set a to ""
	
	repeat with i from 1 to the count of songLocations
		set thisItem to (item i of songLocations) as alias
		set thisPOSIXPath to (the POSIX path of thisItem)
		set a to a & "
" & thisPOSIXPath
	end repeat
	
	a
end tell
