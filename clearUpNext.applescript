#!/usr/bin/env osascript
# Bilal Syed Hussain
activate application "iTunes"
tell application "System Events"
	tell process "iTunes"
		click (first button of scroll area 1 of window "iTunes" whose description is "up next")
		delay 1
		set upNextButton to button 4 of scroll area 1 of window 1
		set pos to upNextButton's position
		
		--  160, 54  the number of pixels away the clear button is 
		set clearX to (item 1 of pos) + 160
		set clearY to (item 2 of pos) + 54
		set cmd to "/usr/local/bin/cliclick -r -- " & {clearX, " ", clearY}
		do shell script cmd
		
		
	end tell
end tell