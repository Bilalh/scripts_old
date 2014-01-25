#!/usr/bin/env osascript
set res to ""
tell application "iTunes"
	set res to Â
    "  :title:  " & (the name of current track as string) & "
" & "  :album:  " & (the album of current track as string) & " 
" & "  :artist: " & (the artist of current track as string) & "
" & "  :track:  " & (the track number of current track as string) & "
" & "  :disc:   " & (the disc number of current track as string)
end tell