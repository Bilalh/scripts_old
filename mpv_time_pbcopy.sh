#!/bin/bash
set -o nounset
OUR="$( cd "$( dirname "$0" )" && pwd )";

"${OUR}/format_seconds.py" "$1" | pbcopy
