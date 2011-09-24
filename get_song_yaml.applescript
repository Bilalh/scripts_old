#!/usr/bin/env osascript
set res to ""
tell application "iTunes"
	set res to "  :artist: " & (the artist of current track as string) & "
" & "  :title:  " & (the name of current track as string) & "
" & "  :album:  " & (the album of current track as string)
end tell