#!/bin/bash
# Bilal Syed Hussain
set -o nounset

# Adds a link to the specified pdf to the bibtex in the clipboard

tmp_name=$(gmktemp --suffix=.bib)
pbpaste > $tmp_name

if [ $# -gt  0 ]; then
	add_local_link_to_bib.py "$tmp_name" "${1:-}"
fi
open -R $tmp_name
open -a "Mendeley Desktop" $tmp_name 
