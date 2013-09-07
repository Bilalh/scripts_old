# Bilal Syed Hussain
# Clears the up next queue
# a itunes window or the mini player has to be visable 
tell application "System Events"
	tell process "iTunes"
		set isMini to false
		local upNextButton
		if title of window 1 is "MiniPlayer" then
			set upNextButton to (first button of window 1 whose description is "show up next")
			--  19, 48  the number of pixels away the clear button is 	
			set offsetX to 19
			set offsetY to 45
			set isMini to true
			
			
		else if title of window 1 is "iTunes" then
			try
				set upNextButton to (first button of scroll area 1 of window 1 whose description is "up next")
			on error
				-- no items in queue
				return 2
			end try
			
			--  160, 54  the number of pixels away the clear button is 
			set offsetX to 160
			set offsetY to 54
			
		else
			return 1
		end if
		
		click upNextButton
		delay 1
		set pos to upNextButton's position
		
		set clearX to (item 1 of pos) + offsetX
		set clearY to (item 2 of pos) + offsetY
		
		set cmd to "/usr/local/bin/cliclick -r -- " & {clearX, " ", clearY}
		do shell script cmd
		
		-- Make sure the up last list is closed
		if isMini then
			set isPlaying to true
			tell application "iTunes"
				if player state is stopped then
					activate
					set isPlaying to false
				end if
				
			end tell
			
			if isPlaying then
				delay 0.1
				click upNextButton
			else
				keystroke "u" using {command down, option down}
				
			end if
		end if
		
	end tell
end tell