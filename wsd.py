#!/usr/bin/env python
# 
# Sends contents of the specified file over to
# websequencediagrams.com and saves the resulting
# image as a png file: <file_path>.png.
# 
# Hashes file contents into a temporary sqlite
# database so that we wouldn't need to
# unnecessarily call the server if the file
# contents haven't changed.
# 
# Run with no arguments to see the usage info.
# 
# Copyright 2009 Ali Rantakari (http://hasseg.org)
# 

# Made some changes to file handing -- Bilal Hussain

import urllib
import re
import os
import sys
import tempfile
import sqlite3
import hashlib
import textwrap



# this function from:
# http://www.websequencediagrams.com/embedding.html
def getSequenceDiagram( text, outputFile, style = 'default' ):
    request = {}
    request["message"] = text
    request["style"] = style

    url = urllib.urlencode(request)

    f = urllib.urlopen("http://www.websequencediagrams.com/", url)
    line = f.readline()
    f.close()

    expr = re.compile("(\?img=[a-zA-Z0-9]+)")
    m = expr.search(line)

    if m == None:
        print "Invalid response from server."
        return False

    urllib.urlretrieve("http://www.websequencediagrams.com/" + m.group(0),
            outputFile )
    return True


def verbosePrint(s):
	if arg_verbose:
		print s



tempfile.gettempdir()
dbfilepath = tempfile.tempdir+os.path.sep+'wsd_db.sqlite'

def removeDB():
	if os.path.exists(dbfilepath):
		verbosePrint('removing DB from: '+dbfilepath)
		os.remove(dbfilepath)

def ensureDBCreated():
	if os.path.exists(dbfilepath):
		return
	
	verbosePrint('creating DB into: '+dbfilepath)
	
	conn = sqlite3.connect(dbfilepath)
	cur = conn.cursor()
	cur.execute('CREATE TABLE IF NOT EXISTS filehashes (path_hash TEXT PRIMARY KEY NOT NULL, content_hash TEXT NOT NULL)')
	cur.close()
	conn.commit()
	conn.close()



styles = [
	'omegapple',
	'default',
	'earth',
	'modern-blue',
	'mscgen',
	'qsd',
	'rose',
	'roundgreen',
	'napkin',
]
defaultstyle = styles[0]


arg_verbose = False
arg_cleandb = False
arg_force = False

for i in range(1,len(sys.argv)):
	if (sys.argv[i] == '--verbose') or (sys.argv[i] == '-v'):
		arg_verbose = True
	if (sys.argv[i] == '--cleandb') or (sys.argv[i] == '-c'):
		arg_cleandb = True
	if (sys.argv[i] == '--force') or (sys.argv[i] == '-f'):
		arg_force = True


if len(sys.argv) == 1:
	print 'usage: '+os.path.basename(sys.argv[0])+' <file> [stylename] [-v|--verbose] [-c|--cleandb]'
	print '       [-f|--force]'
	print
	print '  Sends contents of <file> over to websequencediagrams.com'
	print '  and saves the resulting image to <file>.png. The first'
	print '  line in <file> must start with #wsd to indicate that'
	print '  the file is a websequencediagrams.com markup file.'
	print
	print '  <file> may contain a style declaration that specifies the'
	print '  style that should be used for it. The syntax for this is:'
	print '  #wsd:style=stylename'
	print
	print '  [stylename] may be one of:'
	print textwrap.fill(', '.join(styles), width=60, initial_indent='  ', subsequent_indent='  ')
	print '  (the default is \''+defaultstyle+'\')'
	print
	print '  -v (or --verbose) makes the output verbose.'
	print '  -c (or --cleandb) removes and regenerates the temporary'
	print '                    database that is used to retain the'
	print '                    hashes of file contents so that we'
	print '                    could check if they have changed.'
	print '  -f (or --force) generates the diagram image regardless'
	print '                  of whether the file contents have changed'
	print '                  or not.'
	print
	sys.exit(0)
else:
	
	filepath = sys.argv[1]
	if not os.path.exists(filepath):
		print 'error: can not find file: '+filepath
		print
		sys.exit(1)
	
	imgpath = os.path.splitext(filepath)[0]+'.png'
	
	f = open(filepath, 'r')
	file_content = f.read()
	f.close()
	
	file_content_lines = file_content.split('\n')
	if len(file_content_lines) > 0 and file_content_lines[0].strip()[0:4] != '#wsd':
		print 'error: first line in file doesn\'t start with #wsd'
		print '       -- assuming file is not a websequencediagrams.com'
		print '       syntax markup file'
		print
		sys.exit(40)
	
	file_path_hash = hashlib.md5(filepath).hexdigest()
	file_content_hash = hashlib.md5(file_content).hexdigest()
	fileChanged = True
	
	if arg_cleandb:
		removeDB()
	ensureDBCreated()
	conn = sqlite3.connect(dbfilepath)
	cur = conn.cursor()
	cur.execute('SELECT content_hash FROM filehashes WHERE path_hash=?', (file_path_hash,))
	row = cur.fetchone()
	if row != None and row[0] == file_content_hash:
		fileChanged = False
		if not arg_force:
			verbosePrint('file hasn\'t changed')
	
	if arg_force or not os.path.exists(imgpath) or fileChanged:
		
		style = defaultstyle
		if (len(sys.argv) > 2) and (sys.argv[2] in styles):
			style = sys.argv[2]
		else:
			# search for "#wsd:style=stylename" declarations in file
			re_style_decl = re.compile('^#\s*wsd:style=([^\s]+)', re.MULTILINE)
			m = re_style_decl.search(file_content)
			if m != None:
				declared_style = m.group(1)
				if declared_style in styles:
					style = declared_style
		
		try:
			getSequenceDiagram(file_content, imgpath, style)
		except IOError:
			print "error: can not connect to server (IOError)"
			sys.exit(50)
		except:
			print "error: unexpected error: "+sys.exc_info()[0]
			sys.exit(51)
		
		if row == None:
			cur.execute('INSERT INTO filehashes VALUES (?,?) ', (file_path_hash, file_content_hash))
		else:
			cur.execute('UPDATE filehashes SET content_hash=? WHERE path_hash=?', (file_content_hash, file_path_hash))
		conn.commit()
		
		verbosePrint('image updated: '+imgpath)
	
	cur.close()
	conn.close()







