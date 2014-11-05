#!/usr/bin/env osascript
tell application "Finder"
	set _cwd to POSIX path of ((folder of (front window)) as alias)
end tell


tell application "iTerm"
	activate
	
	try
		set _session to current session of current terminal
	on error
		set _term to (make new terminal)
		tell _term
			make new session
			set _session to current session
		end tell
	end try
	
	tell _session
		write text "cd \"" & _cwd & "\""
	end tell
end tell