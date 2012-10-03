#!/usr/bin/python
import os
import re
import sys

if len(sys.argv) != 2:
    sys.exit('Usage: %s filename' % sys.argv[0])

with open(os.path.abspath(sys.argv[1])) as f:
    s = f.read()


s = re.sub(r';', r',',s)
s = re.sub(r'    ?([\{\[(])', r'@\1',s)
s = re.sub(r'(".*?")', r'@\1', s)
s = re.sub(r'= ', r': ', s)
s = re.sub(r'([{,]\s+)(\w+)\s*: ', r'\1@"\2" :', s)
s = s.replace('\U','\u')
s = s.replace('@(', '@[')
s = s.replace('),', '],')
s = re.sub(r'^(\s*){(\s*)@', r'\1@{\2@',s)
s = re.sub(r'(:\s*)(\d+)(\s*)([,\{\[])',r'\1@(\2)\3\4', s)

s = re.sub(r'(@[\[\{])(\s*)(\w+)(\s*)([\]\}])', r'\1\2@"\3"\4\5',s  )
s = re.sub(r'(,\s*)(\w+)(\s*,)',r'\1@"\2"\3',s)
s = re.sub(r'(@[\[\{]\s*)(\w+)(\s*,)',r'\1@"\2"\3',s)
s = re.sub(r'(,\s*)(\w+)(,?\s*[\]\}])',r'\1@"\2"\3',s)
s = re.sub(r'(:\s*)(\w+)(,?\s*[\]\}])',r'\1@"\2"\3',s)
s = re.sub(r'(:\s*)(\w+)(,)',r'\1@"\2"\3',s)


print s