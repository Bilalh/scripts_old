#!/bin/sh
glob=$1
shift
for i in ${glob}; do
	remove_elems_inline.rb "$i" $*; 
done
