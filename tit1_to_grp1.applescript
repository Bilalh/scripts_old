-- iTunes use grp1 for new grouping, and tit1 for work. This force the track to be rewritten such that grp1 field is updated with the grouping infomation.
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
		set group to (get grouping of thisTrack)
		set group1 to group & "@"
		set grouping of thisTrack to group1
		set grouping of thisTrack to group
	end repeat
	
end tell