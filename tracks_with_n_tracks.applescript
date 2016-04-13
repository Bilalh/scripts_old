#!/usr/bin/env osascript
tell application "iTunes"
	-- The number of tracks
	set songsPerAlbum to 10
	set albumPlaylistName to "album_results"
	
	-- Look in the whole library 
	-- set place to library playlist 1 
	
	-- Only look in this playlist
	set place to playlist "to_fix2"
	
	-- Get list of albums, the fast way...
	set albumsWithDups to (album of every track)
	set albumsNames to my removeDuplicates(albumsWithDups)
	
	-- Create playlist
	if user playlist albumPlaylistName exists then
		try
			delete tracks of user playlist albumPlaylistName
		end try
	else
		make new user playlist with properties {name:albumPlaylistName}
	end if
	
	
	-- Check each album
	repeat with currentAlbum in albumsNames
		set albumSongs to (every track of place whose album is currentAlbum)
		
		-- Check track count
		if (count of albumSongs) is less than or equal songsPerAlbum then
			--log "Debug: Album: " & currentAlbum
			repeat with trk in albumSongs
				--log "Debug:      " & (get name of trk)
				
				try
					duplicate trk to user playlist albumPlaylistName
				end try
				
			end repeat
		end if
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
			if k's res does not contain {itm} then �
				set k's res's beginning to itm
		end repeat
		return k's res's reverse
	on error eMsg number eNum
		error "Can't removeDuplicates: " & eMsg number eNum
	end try
end removeDuplicates