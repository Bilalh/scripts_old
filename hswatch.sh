#/bin/bash

# had to 'set backupcopy=yes' in ~/.vimrc to make vim happy

watchmedo shell-command src \
	--patterns="*.hs" \
	--ignore-directories \
	--recursive \
	--command='hsfile.sh "${watch_src_path}"'" $@" \
		| egrep -v 'Compiling|Loading' 

