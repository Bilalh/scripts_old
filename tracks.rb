#!/usr/bin/env ruby19 -wKU
# Prints out the infomation about playcounts from a specifed YAML file
# Bilal Syed Hussain

require "yaml"
require "pp"
require 'trollop'

Sorts = {
	name:     -> k,v { k }                                    ,
	tracks:   -> k,v { -v[:total_tracks]}                     ,
	creation: -> k,v { v[:creation]}                          ,
	plays:    -> k,v { -v[:total_count]}                      ,
	finished: -> k,v { -v[:played].to_f/v[:total_tracks].to_f}
}

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

# option parser
ops = Trollop::options do
	opt :name      , "Sort by name"
	opt :tracks    , "Sort by total tracks"
	opt :creation  , "Sort by creation date"
	opt :plays     , "Sort by play counts"
	opt :finished  , "Sort by percents played"
	opt :all       , "Shows all Folders in Directory"
end

sorter = Sorts[:name]
Sorts.each_key do |k|
	if ops[k] then
		sorter = Sorts[k]
		break
	end
end

hash = YAML::load File.open YAML_FILE 

# Getting the data

arr=hash.to_a.map do |e|
	[e[0].gsub(%r{/Users/bilalh/Movies/add/}, '')
	    .gsub(%r{^./}, ''),e[1]]
end.sort

albums = {}
arr.each do |track|
	name  = track[0][/(.*?)\//,1]
	
	album = albums[name] || {total_count:0, total_tracks:0,played:0}
	album[:total_count] += track[1]
	
	if album[:total_tracks] = 0 then
		album[:total_tracks]  =  Dir["#{DIR_LOCATION}/#{name}/**/*{mp3,m4a,flac}"].length
		album[:creation]      =  creation_time("#{DIR_LOCATION}/#{name}")
	end
	album[:played]+=1
	albums[name] = album
end

if ops[:all] then
	Dir["#{DIR_LOCATION}/*/"].each do |f|
		name = File.basename f
		unless albums.has_key? name
			count = Dir["#{DIR_LOCATION}/#{name}/**/*{mp3,m4a,flac}"].length
			albums[name] = {total_count:0, total_tracks:count,played:0, creation:creation_time("#{DIR_LOCATION}/#{name}")}
		end
	end
end

# Printing
printf  "%-51s %4s  %4s %3s %s\n", "Album", "Tracks", "Plays", "Played?", "Date"
albums.sort_by { |k,v| sorter[k,v] }.each do |e|
	album  = e[0]
	values = e[1]
	
	printf  "%-54s %3d  %5d %-7s %s\n", album, values[:total_tracks], values[:total_count], 
	(values[:played] ==values[:total_tracks]) ? "Yes" : "%3d/%-3d" % [values[:played],values[:total_tracks]],
	values[:creation].strftime('%b %d')
end