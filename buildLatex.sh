#!/bin/bash
set -o nounset
set -e
set -x
mkdir -p "$(dirname ${TEXPAD_ROOTFILE:-$1})/.latexmk"
parallel "mkdir -p  $(dirname ${TEXPAD_ROOTFILE:-$1})/.latexmk/{}" ::: $(find . -not -path '*/\.*' -type d)

latexmk -pdf "${TEXPAD_ROOTFILE:-$1}"  -outdir="$(dirname ${TEXPAD_ROOTFILE:-$1})/.latexmk"

set +x
