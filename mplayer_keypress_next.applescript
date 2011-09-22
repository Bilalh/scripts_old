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
  -- do shell script "sed -i -e '1d' '/Users/bilalh/Desktop/_playlist.m3u'"
  do shell script "file='/Users/bilalh/Desktop/_counter'; if [ -f \"$file\" ]; then  num=$(echo \"1+$(cat \"$file\")\" | bc); echo $num | bc > \"$file\"; else echo '1' > \"$file\";  fi"
end run