#!/bin/bash
# Makes a scatter graph
if [ $# -lt 4 ]; then
	echo "$0 file output.pdf xlabel ylabel"
	echo "Make a scatter graph using the column 1 as x and column 2 as y"
	exit
fi
gnuplot <<-EOF        
set terminal pdf
set output "${2}"
set xlabel "${3}"
set ylabel "${4}"
set key right bottom
plot  "${1}" using 1:2
EOF