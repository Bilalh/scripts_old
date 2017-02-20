#!/usr/bin/env osascript
on toLower(s)
	tell AppleScript to return do shell script "shopt -u xpg_echo; export LANG='" & user locale of (system info) & ".UTF-8'; echo " & quoted form of s & " | tr [:upper:] [:lower:]"
end toLower
tell application "iTunes" to set title to the name of current track as string
set leftside to toLower(title)

set res to ""
tell application "iTunes"
	set res to leftside & ":" & "
" & "  :title:  " & title & "
" & "  :album:  " & (the album of current track as string) & " 
" & "  :artist: " & (the artist of current track as string) & "
" & "  :track:  " & (the track number of current track as string) & "
" & "  :disc:   " & (the disc number of current track as string)
end tell