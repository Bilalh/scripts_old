#!/usr/bin/python
# -*- coding: utf-8 -*-
# Bilal Syed Hussain

"""
Adds a link to the specified pdf to the bibtex bib
"""

import re
from string import Template
import sys

if len(sys.argv) != 3:
    print "{} bib_path pdf_path".format(sys.argv[0])
    sys.exit()

bib_path = sys.argv[1]
pdf_path = sys.argv[2]


url_template = Template(",\nlocal-url= {$url}}")
url = url_template.substitute(url=pdf_path)

with open(bib_path,'r+') as f:
    bib = f.read()
    if bib.find('local-url') < 0:
        res = re.sub(r"}(\s|\n)*$",url,bib)
        f.seek(0)
        f.write(res)

print "Added link to {} in {}".format(pdf_path,bib_path)
