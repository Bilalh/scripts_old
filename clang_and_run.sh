#!/bin/bash
set -o nounset

pushd "$(dirname "$1")" &>/dev/null

clang++ -std=c++11 "${1}" -o "${1%.*}.out" && "./${1%.*}.out"

popd &>/dev/null