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
echo "using ${Vs} cores"

function process(){

	dir="$1"
	if [[ "$dir" == "." ]]; then
		return 0
	fi

	cd  "$dir"
	echo "Starting from $PWD"

	video=$( find . -maxdepth 1 -type f -type f                              \
		\( -name '*.mkv' -o -name '*.mp4' -o -name '*.wmv' -o -name '*.flv'  \
			-o -name '*.webm' -o -name '*.mov' \)                            \
		\( -not -name 'out.*' \) )
	max_vol=$(encode_to_vp8.sh "${video}"  00:00:00.000 end 2>&1 \
		| grep max_volume | egrep -o -- "-?[0-9]+(\.[0-9]+)? dB" | cut -d ' ' -f 1)

	echo "video is ${video}"
	echo "maxvol is ${max_vol} Db"
	#normalising to -0.4dB.
	vol=$(perl -e "print ((${max_vol} * -1.0) - 0.4)")
	echo "For normalising to -0.4dB: ${vol} Db"


	[ -f "ffmpeg2pass-0.log" ] &&  rm "ffmpeg2pass-0.log"

	if [ -f "times" ]; then
		read -r begin end < <(head "times")
		echo "Using custom times: ${begin} ${end}"
	fi
	begin="${begin:-00:00:00.000}"
	end="${end:-end}"

	cmd=(encode_to_vp8.sh "${video}" "${begin}" "${end}" "${vol}" out.webm)
	subs="${video%.*}.ssa"
	if [ -f "${subs}" ]; then
		echo "subs is ${subs}"
		cmd+=("${subs}")
	fi
	echo "${cmd[@]}"
	"${cmd[@]}"

	echo "Ending from $PWD"
}
export -f process

parallel -j"$Vs" --joblog par.job --tagstring "{}" \
	"process {} 2>&1 | tee {}/output.log  " \
	:::: <(find . -maxdepth 1 -type d | sort  )
