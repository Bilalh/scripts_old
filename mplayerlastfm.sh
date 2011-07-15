#!/bin/bash
# mplayerlastfm - simple scrobbling mplayer wrapper
#
# Prerequisites:
#	* Get and setup http://www.red-bean.com/~decklin/software/lastfmsubmitd/
#   * Get taginfo http://freshmeat.net/projects/taginfo
#
# Install this script with some handy name, e.g. '/usr/local/bin/m'.
#
# Known problems:
#	* 'q' interrupts only playback of current file; press and *hold* ctrl-C
#	* even if you skip file immediately with Enter or 'q', it gets scrobbled - see below
#
# Song info will be submitted after you finish listening to the song;
# if you are SKIPPING a track and don't want it to appear, press Ctrl-C
# in mplayer - it will skip to the next track without scrobbling.

# ([ -f var/run/lastfm/lastfmsubmitd.pid ] && kill -0 `cat /var/run/lastfm/lastfmsubmitd.pid` 2>&1) || lastfmsubmitd
[ "$LASTFM_PLAYER" ] || LASTFM_PLAYER=mplayer
[ "$MUSICTAG" ]      || TAGINFO=taginfo
[ "$LASTFM_SUBMIT" ] || LASTFM_SUBMIT=lastfmsubmit

scrobble () {
	read album;
	read artist;
	read title;
	read time;
	
	[ "$album" = "1" ] && album=""
	echo "## Last.FM : -l \"`printf '%d:%d' $(($time%3600/60)) $(($time%60))`\" -a \"$artist\" -b \"$album\" --title \"$title\""
	$LASTFM_SUBMIT -e utf8 \
		-l "$time" -a "$artist" -b "$album" --title "$title"
}

for f; do
	$LASTFM_PLAYER "$f" || continue

	case "$f" in
	*.mp3 | *.m4a)
		$TAGINFO "$f" \
		|  egrep 'ALBUM|LENGTH|ARTIST|TITLE'   \
		|  grep -oP '"(.*)"' \
		|  grep -oP "[\w ]+"  \
		|  scrobble
		;;
	esac
done