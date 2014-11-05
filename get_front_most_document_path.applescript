#!/usr/bin/env osascript
tell application "System Events"
	set theprocess to the first process whose frontmost is true
	set thetitle to the value of the attribute "AXTitle" of theprocess
	set thewindow to the value of attribute "AXFocusedWindow" of theprocess
	set thefile to the value of attribute "AXDocument" of thewindow as string
	if thetitle is "Finder" then
		tell application "Finder"
			set thefile to (POSIX path of (target of the first window as alias))
		end tell
	end if
	set thefile to thefile
end tell