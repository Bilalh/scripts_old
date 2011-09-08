#!/bin/sh
remove_duplicates_from_file.rb ~/.bash_history > ~/.bash_history.tmp
mv  ~/.bash_history.tmp  ~/.bash_history