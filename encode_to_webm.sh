#!/bin/bash
# 2 Pass vp9 in webm
set -o nounset
set -o errexit

if [ $# -eq 0 ]; then
	echo "encode_to_webm.sh file -ss -t"
	echo "encode_to_webm.sh file -ss -t max_vol(dB) out [subs]"
	echo "   e.g. b.mkv 00:00:00.700 00:01:27.200"
	echo "   e.g. b.mkv 00:00:00.700 00:01:27.200 -5.8 out.webm [subs.ssa]"
	echo ""
	echo "2 Pass vp9 in webm"
	echo "first versions gives max volume of the file"
	echo "second version encodes and optionally hard subs the the given sub file"
	exit 0
fi

file="$1"  #  b.mkv
ss="$2"    #  00:00:00.700
t="$3"     #  00:01:27.200

if [ -z "${4:-}" ]; then
	ffmpeg -ss "${ss}"  -i "${file}"   -t "${t}" \
	-af "volumedetect" -f null /dev/null
	exit 0
fi

vol="$4"  # -5.4
out="$5"

if [ !  -f "ffmpeg2pass-0.log" ]; then
	ffmpeg  -ss "${ss}"  -i "${file}"   -t "${t}" \
		-pass 1 -c:v libvpx-vp9 -b:v 2400k -maxrate 3200k -qcomp 0.3 -speed 4 \
		-g 240 -slices 4 -threads 7 -tile-columns 6 -frame-parallel 1 \
		-auto-alt-ref 1 -lag-in-frames 25 -an -sn -f webm -y /dev/null
fi

if [ -n "${6:-}" ]; then
	if [ ! -f "$6" ]; then
		echo "$6 does not exist"
		exit 1
	fi
	ffmpeg -ss "${ss}"  -i "${file}"   -t "${t}"\
		-pass 2 -c:v libvpx-vp9 -b:v 2400k -maxrate 3200k -bufsize 6000k -qcomp 0.3 -speed 1 \
		-g 240 -slices 4 -vf subtitles="$6" \
		-threads 7 -af "volume=${vol} dB:precision=double" \
		-tile-columns 6 -frame-parallel 1 -auto-alt-ref 1 -lag-in-frames 25 \
		-c:a libvorbis -b:a 192k -sn -f webm -y "${out}"

else
	ffmpeg -ss "${ss}"  -i "${file}"   -t "${t}"\
		-pass 2 -c:v libvpx-vp9 -b:v 2400k -maxrate 3200k -bufsize 6000k -qcomp 0.3 -speed 1 \
		-g 240 -slices 4 \
		-threads 7 -af "volume=${vol} dB:precision=double" \
		-tile-columns 6 -frame-parallel 1 -auto-alt-ref 1 -lag-in-frames 25 \
		-c:a libvorbis -b:a 192k -sn -f webm -y "${out}"
fi


