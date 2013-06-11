#!/usr/bin/env osascript -s h
# Get the track and disc number for the specifed data
on run argv
	--(*
	set theAlbum to item 1 of argv as Unicode text
	set theTitle to item 2 of argv as Unicode text
	set theArtist to item 3 of argv as Unicode text
	--*)
	(*
	set theAlbum to "stone cold" as Unicode text
	set theTitle to "stone cold" as Unicode text
	set theArtist to "Yuki Kajiura" as Unicode text
	*)
	
	set arr to []
	tell application "iTunes"
		set results to tracks whose Â
			album is equal to theAlbum Â
			and name is equal to theTitle Â
			and artist is equal to theArtist
		
		repeat with i from 1 to the count of results
			set meta to item i of results
			set arr to arr & [track number of meta, disc number of meta, time of meta]
		end repeat
		
	end tell
	arr
	
end run