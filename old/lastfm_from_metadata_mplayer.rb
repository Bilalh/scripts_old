#!/usr/bin/env ruby19  -wKU
require "yaml"
require "pp"

LASTFM_SUBMIT='/usr/local/bin/lastfmsubmit'
METADATA_FILE="/Users/bilalh/Movies/.Movie/OpeningP/_metadata.yaml"
MPLAYER_BINARY="/Users/bilalh/Library/Application Support/MPlayer OSX Extended/Binaries/mplayer-git.mpBinaries/Contents/MacOS/mplayer"


args= ['-profile tt', '--', 
	"/Users/bilalh/Movies/.Movie/OpeningP/Aoi Hana op 1  creditless sub.mkv",
	"/Users/bilalh/Movies/.Movie/OpeningP/Clannad After Story op 1 creditless 1080.mp4"]
# args = ARGV

filenames = nil
args.each_with_index do |e, i|
	if e == '--' then
		filenames = args[i+1..-1]
		args = args[0...i]
		break
	end
end
# pp args
# pp filenames
args << "-quiet" << "-slave" << "-fixed-vo" << "-idle" << "-input" << "file=/Users/bilalh/.mplayer/pipe"
args_s =  args.join " "

metadata = YAML::load( File.open(METADATA_FILE)) || (puts "no metadata file"; {})

puts %{"#{MPLAYER_BINARY}" #{args_s}}
puts `"#{MPLAYER_BINARY}" #{args_s} &`

filenames.each do |file|
	# `echo 'loadfile #{file}' > ~/.mplayer/pipe`
	`echo "loadfile \"/Users/bilalh/Movies/.Movie/OpeningP/Aoi Hana op 1  creditless sub.mkv\"\n" > ~/.mplayer/pipe`
	
	m = metadata[File.basename file] || (puts "no metadata for '#{File.basename file}'"; next)
	pp m

	# using fake length for now
	# length = `mediaInfo --Inform='Video;%Duration/String3%' "#{filename}" | sed "s/\.[0-9][0-9]*$//"`
	length = "1:30"

	puts %{#{LASTFM_SUBMIT} -e utf8 -a "#{m[:artist]}" -b "#{m[:album]}" --title "#{m[:title]}" -l "#{length}"}
	# scrobbles the track
	# puts `kill $(ps aux | grep lastfmsubmitd | grep -v grep  | awk '{print $2}') &>/dev/null;\ 
	#{LASTFM_SUBMIT} -e utf8 -a "#{m[:artist]}" -b "#{m[:album]}" --title "#{m[:title]}" -l "#{length}"; lastfmsubmitd&`
	
end
