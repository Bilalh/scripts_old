#!/usr/bin/env osascript
on run argv
	tell application "mplayer-git.mpBinaries"
		activate
		tell application "System Events"
			tell process "mplayer"
				
				repeat with i from 1 to number of items in argv
					try
						keystroke item i of argv
					end try
				end repeat
				
			end tell
		end tell
	end tell
end run

