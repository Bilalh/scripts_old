#!/bin/bash

# encode_to_vp8_all_par.sh
# Encodes all the videos in the current subdirectories e.g

# dir1/<video.ext>
# dir2/<video.ext>
#      <video.ssa>
# dir3/<video>
#      <times>

# Uses encode_to_vp8.sh to do the enocding output name is out.webm.
# If <video.ssa> is in the directory it will burned into the video
# if times exist it using these times otherwise the whole video will be encoded
# times in the format <start> <end> e.g. one of the following
#	00:00:00.000 00:01:22.040
#	00:00:00.000 end

set -o nounset
export Vs=${Vs:-"1"}
echo "Encoding ${Vs} videos at the same time"

function process(){

	dir="$1"
	if [[ "$dir" == "." ]]; then
		return 0
	fi

	cd  "$dir"
	echo "Starting($(date +'%a %d %b %Y %k:%M:%S %z')) from $PWD"

	video=$( find . -maxdepth 1 -type f                                       \
		\( -name '*.mkv' -o -name '*.mp4' -o -name '*.webm' -o -name '*.flv'  \
			-o -name '*.wmv' -o -name '*.mov' \)                              \
		\( -not -name 'out.*' \) )

	if [ -z "${video}" ]; then
		echo "No video in $dir"
		exit 43
	fi


	max_vol=$(encode_to_vp8.sh "${video}"  00:00:00.000 end 2>&1 \
		| grep max_volume | egrep -o -- "-?[0-9]+(\.[0-9]+)? dB" | cut -d ' ' -f 1)

	echo "video is ${video}"
	echo "maxvol is ${max_vol} Db"
	#normalising to -0.4dB.
	vol=$(perl -e "print ((${max_vol} * -1.0) - 0.4)")
	echo "For normalising to -0.4dB: ${vol} Db"


	[ -f "ffmpeg2pass-0.log" ] &&  rm "ffmpeg2pass-0.log"

	if [ -f "times" ]; then
		# read -r begin end < <(head "times")
		while read -r  b e ; do begin="$b" ; end="$e"; done <times
		echo "Using custom times: ${begin} ${end}"
	fi

	begin="${begin:-00:00:00.000}"
	end="${end:-end}"

	cmd=(encode_to_vp8.sh "${video}" "${begin}" "${end}" "${vol}" out.webm)

	for subs in "${video%.*}.ssa" "${video%.*}.ass"; do
		if [ -f "${subs}" ]; then
			echo "subs is ${subs}"
			cmd+=("${subs}")
			break
		fi
	done

	echo "${cmd[@]}"
	"${cmd[@]}"
	code=$?

	echo "Ending($(date +'%a %d %b %Y %k:%M:%S %z')) from $PWD"
	sleep 60
	return $code
}
export -f process

if [ -f "_files" ]; then
	echo "Reading file list from _files"
	parallel -j"$Vs" --resume-failed --halt 2  --joblog par.job --tagstring "{}" \
		"set -o pipefail; ( process {} 2>&1 | tee {}/output.log ) " \
		 :::: _files
else
	echo "Processing each dir"
	parallel -j"$Vs" --resume-failed --halt 2  --joblog par.job --tagstring "{}" \
		"set -o pipefail; ( process {} 2>&1 | tee {}/output.log ) " \
		:::: <(find . -maxdepth 1 -type d | sort )
fi


