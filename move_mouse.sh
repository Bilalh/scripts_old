#!/bin/zsh
# Bilal Syed Hussain

set -x
cliclick p | ggrep -Po '(\d+),(\d+)' | IFS=, read x y 
echo $x $y 

if [ $x -le 1440 ]; then
	# i.e.  on laptop
	cliclick m:2011,397 
else
	cliclick m:708,445
fi
cliclick dd:.
cliclick du:.
set +x
