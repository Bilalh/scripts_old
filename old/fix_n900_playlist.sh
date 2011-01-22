#!/bin/bash

for i in /Volumes/Nokia\ N900/Music/Playlists/* 
do
	sed -i back 's!\.\./Music/!../!' "$i"
done
