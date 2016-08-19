#!/bin/bash
set -o nounset
OUR="$( cd "$( dirname "$0" )" && pwd )";

url="$(osascript -e 'tell application "Safari" to get the URL of current tab of window 1')"


"${OUR}/mal_tags.py" "${url}" "$@"
