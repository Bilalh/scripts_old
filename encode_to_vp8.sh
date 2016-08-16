#!/bin/bash
# 2 Pass vp9 in webm
set -o nounset
set -o errexit

if [ $# -eq 0 ]; then
	echo "encode_to_webm.sh file [start] [end]"
	echo "encode_to_webm.sh file [start] [end]  adjust_vol(dB) out [subs]"
	echo "   e.g. b.mkv 00:00:00.700 00:01:27.200"
	echo "   e.g. b.mkv 00:00:00.700 end"
	echo "   e.g. b.mkv 00:00:00.700 00:01:27.200 -5.8 out.webm [subs.ssa]"
	echo ""
	echo "2 Pass vp8 in webm"
	echo "first versions gives max volume of the file"
	echo "second version encodes and optionally hard subs the the given sub file"
	exit 0
fi

file="$1"  #  b.mkv
ss="$2"    #  00:00:00.700

if [ "$3" != "end" ]; then

adjusted=$(ruby <<-RUBY
require "Time"
def time_diff(time1_str, time2_str)
  t = Time.at( Time.parse(time2_str) - Time.parse(time1_str) )
    (t - t.gmt_offset).strftime('%H:%M:%S.%L')
end
print time_diff("${2}","${3}")
RUBY
)
	t="-t ${adjusted}"     #  00:01:27.200
	echo "Encoding from $2 to $3, duration ${adjusted}"
else
	t=""
	echo "Encoding from $2 to <end>"
fi



if [ -z "${4:-}" ]; then
	ffmpeg -ss "${ss}"  -i "${file}" ${t} \
	-af "volumedetect" -f null /dev/null
	exit 0
fi

vol="$4"  # -5.4

re='^-?[0-9]+([.][0-9]+)?$'
if ! [[ "$vol" =~ $re ]] ; then
	echo "\$4 is not a integer, $vol"
	exit 3
fi



out="$5"

if [ "${out}" = "${file}" ]; then
	echo "input and output can not be the same"
	exit 4
fi
set -x
if [ !  -f "ffmpeg2pass-0.log" ]; then
	ffmpeg  -ss "${ss}"  -i "${file}"  ${t} \
		-pass 1 -c:v libvpx -b:v 2400k -maxrate 3200k -qcomp 0.3 -speed 4 \
		-g 240 -slices 4 -threads 7   \
		-auto-alt-ref 1 -lag-in-frames 25 -an  -map_metadata -1 -sn -f webm -y /dev/null
fi


if [ -n "${6:-}" ]; then
	if [ ! -f "$6" ]; then
		echo "$6 does not exist"
		exit 1
	fi
	ffmpeg -ss "${ss}"  -i "${file}"  ${t} \
		-pass 2 -c:v libvpx -b:v 2400k -maxrate 3200k -bufsize 6000k -qcomp 0.3 -speed 1 \
		-g 240 -slices 4 -vf subtitles="$6" \
		-threads 7 -af "volume=${vol} dB:precision=double" \
		 -auto-alt-ref 1 -lag-in-frames 25 \
		-c:a libvorbis -b:a 192k  -map_metadata -1 -sn -f webm -y "${out}"

else
	# For encoding picture based subtitles e.g. a   .idx/sub
	# -filter_complex "[0:v][0:s]overlay[v]" -map '[v]' -map 0:a  \
	#  Crop 4:3 out of 16:9 720p
	# -filter:v "crop=960:720:160:0" \
	ffmpeg -ss "${ss}"  -i "${file}"   ${t} \
		-pass 2 -c:v libvpx -b:v 2400k -maxrate 3200k -bufsize 6000k -qcomp 0.3 -speed 1 \
		-g 240 -slices 4 \
		-threads 7 -af "volume=${vol} dB:precision=double" \
		-auto-alt-ref 1 -lag-in-frames 25 \
		-c:a libvorbis -b:a 192k  -map_metadata -1 -sn -f webm -y "${out}"
fi

set +x
