#!/usr/bin/env ruby19 -wKU
# Prints out the infomation about playcounts
require "yaml"
require "pp"

SORT_NAME   =-> k,v { k }
SORT_TOTAL  =-> k,v { -v[:total_tracks]}
SORT_CREATE =-> k,v { v[:creation]}
SORT_PLAYS  =-> k,v { -v[:total_count]}
SORT_PLAYED =-> k,v { -v[:played].to_f/v[:total_tracks].to_f}

YAML_FILE   =File.expand_path "~/Music/playcount.yaml" 
DIR_LOCATION="/Users/bilalh/Movies/add"

require 'open3'
require 'time'
def creation_time(file)
   Time.parse(Open3.popen3("mdls", 
                          "-name",
                          "kMDItemFSCreationDate", 
                          "-raw", file)[1].read)
end

sorter = SORT_NAME

hash = YAML::load File.open YAML_FILE 

arr=hash.to_a.map do |e|
	[e[0].gsub(%r{/Users/bilalh/Movies/add/}, '')
	    .gsub(%r{^./}, ''),e[1]]
end.sort

albums = {}
arr.each do |track|
	name  = track[0][/(.*?)\//,1]
	
	album = albums[name] || {total_count:0, total_tracks:0,played:0}
	# album = albums[name] || {tracks:[], total_count:0, total_tracks:0,played:0}
	# album[:tracks] << track
	album[:total_count] += track[1]
	
	if album[:total_tracks] = 0 then
		album[:total_tracks]  =  Dir["#{DIR_LOCATION}/#{name}/**/*{mp3,m4a,flac}"].length
		album[:creation]      =  creation_time("#{DIR_LOCATION}/#{name}")
	end
	album[:played]+=1
	albums[name] = album
end


printf  "%-51s %4s  %4s %3s %s\n", "Album", "Tracks", "Plays", "Played?", "Date"
albums.sort_by { |k,v| sorter[k,v] }.each do |e|
	album  = e[0]
	values = e[1]
	
	printf  "%-54s %3d  %5d %-7s %s\n", album, values[:total_tracks], values[:total_count], 
	(values[:played] ==values[:total_tracks]) ? "Yes" : "%3d/%-3d" % [values[:played],values[:total_tracks]],
	values[:creation].strftime('%b %d')
end