#!/bin/bash
# Extract subtitles from each MKV file in the given directory
set -x
# If no directory is given, work in local dir
if [ "$1" = "" ]; then
  DIR="."
else
  DIR="$1"
fi

# Get all the MKV files in this dir and its subdirs
find "$DIR" -type f -name '*.mkv' | while read filename
do
  # Find out which tracks contain the subtitles
  mkvmerge -i "$filename" | grep 'subtitles' | while read subline
  do
	# Grep the number of the subtitle track
	tracknumber=`echo $subline | egrep -o "[0-9]{1,2}" | head -1`

	# Get base name for subtitle
	subtitlename=${filename%.*}

	# Extract the track to a .tmp file
	`mkvextract tracks "$filename" $tracknumber:"$subtitlename.ssa" > /dev/null 2>&1`
	`chmod g+rw "$subtitlename.ssa"`

    # # Do a super-primitive language guess: ENGLISH
    #     langtest=`egrep -ic ' you | to | the ' "$subtitlename".ssa.tmp`
    #     trimregex=""
    #
    #
    # # Check if subtitle passes our language filter (10 or more matches)
    # if [ $langtest -ge 10 ]; then
    #   # Regex to remove credits at the end of subtitles (read my reason why!)
    #   `sed 's/\r//g' < "$subtitlename.ssa.tmp" \
    #     | sed 's/%/%%/g' \
    #     | awk '{if (a){printf("\t")};printf $0; a=1; } /^$/{print ""; a=0;}' \
    #     | grep -iv "$trimregex" \
    #     | sed 's/\t/\r\n/g' > "$subtitlename.ssa"`
    #   `rm "$subtitlename.ssa.tmp"`
    #   `chmod g+rw "$subtitlename.ssa"`
    # else
    #   # Not our desired language: add a number to the filename and keep anyway, just in case
    #   `mv "$subtitlename.ssa.tmp" "$subtitlename.$tracknumber.ssa" > /dev/null 2>&1`
    # fi
  done
done
set +x