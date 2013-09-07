#!/usr/bin/env osascript
# Bilal Syed Hussain
activate application "iTunes"
tell application "System Events"
	tell process "iTunes"
		set upNextButton to (first button of window "MiniPlayer" whose description is "show up next")
		click upNextButton
		delay 1
		
		set pos to upNextButton's position
		--  19, 48  the number of pixels away the clear button is 
		set clearX to (item 1 of pos) + 19
		set clearY to (item 2 of pos) + 45
		
		set cmd to "/usr/local/bin/cliclick -r -- " & {clearX, " ", clearY}
		do shell script cmd
		
		delay 0.1
		click upNextButton
		
	end tell
end tell