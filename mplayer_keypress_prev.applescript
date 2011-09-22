#!/usr/bin/env osascript
on run argv
	tell application "mplayer-git.mpBinaries"
		activate
		
		tell application "System Events"
			tell process "mplayer"
				try
					keystroke item 1 of argv
				end try
			end tell
		end tell
	end tell
  do shell script "file='/Users/bilalh/Desktop/_counter'; if [ -f \"$file\" ]; then  num=$(echo \"-1+$(cat \"$file\")\" | bc); echo $num | bc > \"$file\"; else echo '0' > \"$file\";  fi"
end run