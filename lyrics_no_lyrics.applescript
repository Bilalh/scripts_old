#!/usr/bin/env osascript
tell application "iTunes"
	
	if exists playlist "No Lyrics" then
		delete tracks of playlist "No Lyrics"
	else
		make new playlist with properties {name:"No Lyrics"}
	end if
	
	
	duplicate (every track of playlist "l5" whose lyrics is equal to "") to playlist "No Lyrics"
	
	
	if exists playlist "Stored Lyrics" then
		delete tracks of playlist "Stored Lyrics"
	else
		make new playlist with properties {name:"Stored Lyrics"}
	end if
	
	
	duplicate (every track of playlist "l5" whose lyrics is not equal to "") to playlist "Stored Lyrics"
	
	
end tell