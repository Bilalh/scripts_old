tell application "iTunes"
	
	set sel to selection of front browser window
	if sel is {} then
		try
			display dialog "Nothing is selected…" buttons {"Quit"} with icon 0
		end try
		return
	end if
	
	
	repeat with i from 1 to (count of sel)
		set thisTrack to item i of sel
		set songName to (get name of thisTrack)
		try
			set movement of thisTrack to songName
		end try
	end repeat
	
end tell