#!/bin/bash
OUR="$( cd "$( dirname "$0" )" && pwd )";
export OUR

parallel -j1 --line-buffer \
	"pushd {};  ${OUR}/encode_to_vp8_all_par.sh; code=\$?; popd; exit \$code" \
	:::: <( find . -depth 1 -type d | sort  )

