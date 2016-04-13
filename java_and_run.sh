#!/bin/bash
set -o nounset

pushd "$(dirname "$1")" &>/dev/null

javac "${1}" && java "${1%.*}"

popd &>/dev/null

