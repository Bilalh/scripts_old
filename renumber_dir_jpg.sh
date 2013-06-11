#!/bin/bash
# Bilal Syed Hussain

set -o nounset

for i in *; do
pushd $i;

rm pages*
rm *navigationView*
ls -1 | sort -n | awk 'BEGIN{ a=0 }{ printf "mv %s %04d.jpg\n", $0, a++ }' | bash;
popd;
done