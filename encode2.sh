#!/bin/bash
# Bilal Hussain

# Rencodes the mkv to mp4 and hard subs the subtitles,
# setting are for a N900

TODO="/Users/bilalh/Movies/.Movie/todo/"
OUTPUT="/Users/bilalh/Movies/.Movie/enc"
form="mp4"

cd "${TODO}"
for i in *.mkv ; do 

	audio="`mediainfo "$i" | grep -A 2 'Audio' | grep 'Format' | head -n 1 | grep -oP '(?<=:).*' | grep -oP '\w+'`"
	asetting=""
	if [ "${audio}" == "Vorbis" ];
	then
		asetting="--audio-bitrate 160 --audio-codec mp3"
	fi
	
	save="${OUTPUT}/${i%\.*}.${form}"
	if [ ! -f "$save" ];
	then
		
		path="`pwd`/${i}"
		setting="`pwd`/setting.xml"
		substrack=`MediaInfo "${i}" | grep -A 1 Text | grep ID | head -n 1 | grep -oP "\d+"`
		mkvextract tracks "${i}" ${substrack}:a.ssa
		sh /Applications/avidemux2_qt4.app/Contents/Resources/script \
		--force-alt-h264 \
		--load "${path}" \
		${asetting} \
		--video-codec xvid \
		--filters ${setting} \
		--output-format ${form}  \
		--save "$save" \
		--quit &>/dev/null
	else
		echo "done ${save}"
	fi
done