#!/usr/bin/env ruby -wKU
# Bilal Hussain

# converts from the format 
#  00:00:50:...gdy ten mur zacznie pIkaE.
#  00:00:06:...i wycipigam d>=oO.
# to ssa format
# Dialogue: 0, 0:00:00:00, 0:00:00:06, JPN,,0000,0000,0000,, BudzI siI ze snu na jawie...

FILE_NAME = "/Users/bilalh/Desktop/untitled text 2"
lines=IO.readlines(FILE_NAME)

lines.each_index do |i|
	break if i == (lines.length - 1)
	text = lines[i] + lines[i+1]
	m = text.match(/(\d{2}:\d{2}:\d{2}):(.*?)\s+(\d{2}:\d{2}:\d{2})/m)
	puts "Dialogue: 0, 0:#{m[1]}, 0:#{m[3]}, JPN,,0000,0000,0000,, #{m[2]}"
end
