#!/usr/bin/env osascript
tell application "System Events" to Â
	set appName to name of the first process whose frontmost is true


tell application appName
	set bs to get bounds of window 1
	set x to ((bs's item 1) + (bs's item 3)) / 2 as integer
	set y to ((bs's item 2) + (bs's item 4)) / 2 as integer
	set cmd to "/usr/local/bin/cliclick -- " & {x, " ", y}
	do shell script cmd
end tell