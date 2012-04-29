#uncheck every second track and check the others

tell application "iTunes"
	set the_selection to the selection
	set i to 1
	repeat with each_song in the_selection
		if i mod 2 = 0 then
			set enabled of each_song to false
		else
			set enabled of each_song to true
		end if
		
		set i to i + 1
	end repeat
end tell