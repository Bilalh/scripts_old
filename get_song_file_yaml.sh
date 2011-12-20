#!/bin/bash

taginfo=${TAGINFO:=taginfo}
filname="`gf`"

function create_yaml () {
	read title;	
	read album;
	read artist;
	
echo "  :artist: ${artist}  
  :title:  ${title}  
  :album:  ${album}"
}


$taginfo --short  2>/dev/null  "${filname}"  |  create_yaml