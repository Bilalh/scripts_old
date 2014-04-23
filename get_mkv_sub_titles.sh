#!/bin/bash
# Bilal Syed Hussain
set -o nounset

subid=$(mkvmerge -i "$1" | grep subtitles | awk -F" " '{print $3}')
mkvextract tracks "$1" $subid"${2:-${1%.*}.ssa}"
