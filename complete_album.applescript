#!/usr/bin/env osascript
tell application "iTunes"
	
	-- The playlists to use
	set inName to "320kbs>"
	set outName to "zz"
	
	
	set allTracks to library playlist 1
	
	
	-- Get list of albums, the fast way...
	set albumsWithDups to (album of every track of playlist inName)
	set albumsNames to my removeDuplicates(albumsWithDups)
	
	-- Create playlist
	if user playlist outName exists then
		try
			delete tracks of user playlist outName
		end try
	else
		make new user playlist with properties {name:outName}
	end if
	
	
	-- Check each album
	repeat with currentAlbum in albumsNames
		set albumSongs to (every track of allTracks whose album is currentAlbum)
		
		--log "Debug: Album: " & currentAlbum
		repeat with trk in albumSongs
			--log "Debug:      " & (get name of trk)
			
			try
				duplicate trk to user playlist outName
			end try
			
		end repeat
	end repeat
end tell

on removeDuplicates(lst)
	local lst, itemRef, res, itm
	try
		if lst's class is not list then error "not a list." number -1704
		script k
			property l : lst
			property res : {}
		end script
		repeat with itemRef in k's l
			set itm to itemRef's contents
			-- note: minor speed optimisation when removing duplicates 
			-- from ordered lists: assemble new list in reverse so 
			-- 'contains' operator checks most recent item first
			if k's res does not contain {itm} then Â
				set k's res's beginning to itm
		end repeat
		return k's res's reverse
	on error eMsg number eNum
		error "Can't removeDuplicates: " & eMsg number eNum
	end try
end removeDuplicates