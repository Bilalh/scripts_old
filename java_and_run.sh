#!/bin/bash
set -o nounset
name="$1"
shift

pushd "$(dirname "$name")" &>/dev/null
javac "${name}" && java "${name%.*}" "$@"

popd &>/dev/null

