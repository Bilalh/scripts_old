#!/bin/bash

DIRECTORY=${1:-~/}

esc () {
STR="$1" ruby <<"RUBY"
   str = ENV['STR']
   str = str.gsub(/'/, "'\\\\''")
   str = str.gsub(/[\\"]/, '\\\\\\0')
   print "'#{str}'"
RUBY
}

osascript <<-APPLESCRIPT
tell app "Terminal"
	launch
	activate
	do script "clear; cd $(esc "${DIRECTORY}");pwd"
	set position of first window to {5, 100}
end tell
APPLESCRIPT