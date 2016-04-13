#/bin/bash
file=${1#$PWD/};
shift;

printf %b '\033c'
if [ -n "$ITERM_ID" ]; then
	osascript -e 'tell application "System Events"' -e "set frontmost of the first process whose unix id is $ITERM_ID to true" -e 'keystroke "k" using command down'   -e "keystroke tab using command down" -e 'end tell';
fi

ghc -odir dist/watched -hidir dist/watched -no-user-package-db -package-db .cabal-sandbox/x86_64-osx-ghc-7.8.3-packages.conf.d -isrc -idist/build/autogen -isrc/exec  "$file" "$@"
[ ! -n "$ITERM_ID" ] && date;
echo "<<end>>"

[ -n "$ITERM_ID" ] &&
	# scroll to the top
	osascript -e 'tell application "System Events"' -e "set frontmost of the first process whose unix id is $ITERM_ID to true" -e 'key code 116 using command down' \
		-e 'end tell' \
		-e 'tell application "TextMate" to activate'
	# -e "keystroke tab using command down" \
