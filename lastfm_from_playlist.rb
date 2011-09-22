#!/usr/bin/env ruby19  -wKU
require "yaml"
require "pp"

LASTFM_SUBMIT='/usr/local/bin/lastfmsubmit'
METADATA_FILE="/Users/bilalh/Movies/.Movie/OpeningP/_metadata.yaml"
PLAYLIST= "/Users/bilalh/Desktop/_playlist.m3u"

filepath = `head #{PLAYLIST}`.strip
`sed -i -e '1d' #{PLAYLIST}`

metadata = YAML::load( File.open(METADATA_FILE)) || (puts "no metadata file"; exit)
m = metadata[File.basename filepath] || (puts "no metadata for '#{File.basename filepath}'"; exit)
pp m

# using fake length for now
# length = `mediaInfo --Inform='Video;%Duration/String3%' "#{filename}" | sed "s/\.[0-9][0-9]*$//"`
length = "1:30"

puts %{#{LASTFM_SUBMIT} -e utf8 -a "#{m[:artist]}" -b "#{m[:album]}" --title "#{m[:title]}" -l "#{length}"}
# scrobbles the track
# puts `kill $(ps aux | grep lastfmsubmitd | grep -v grep  | awk '{print $2}') &>/dev/null;\ 
#{LASTFM_SUBMIT} -e utf8 -a "#{m[:artist]}" -b "#{m[:album]}" --title "#{m[:title]}" -l "#{length}"; lastfmsubmitd&`


