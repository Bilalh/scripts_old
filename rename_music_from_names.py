#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import re
import sys
from pprint import pprint as pp
import itertools

"""
Adds number to files. 
Assumes newnames is Structured as follows:
1.
songname
"""


def parse_file(fname):
    names_to_num = {}
    with open(fname) as f:
        for l1,l2 in itertools.izip_longest(*[f] * 2):
            num = int(l1[0:-2])
            name = l2.strip()
            names_to_num[name] = num
    return names_to_num


def transform_names(mapping, dname):
    filenames = os.listdir(dname)
    for filename in filenames:
        arr = os.path.splitext(filename)
        name, ext = arr
        num = mapping[name]

        newname = "%02d %s%s" % (num,name,ext)
        newpath = os.path.join(dname,newname)
        oldpath = os.path.join(dname, filename)
        os.rename(oldpath,newpath)
        print "%s -> %s" % (filename, newname)


if len(sys.argv) != 3:
    sys.exit('Usage: %s newnames directory' % sys.argv[0])

fname, dname = sys.argv[1:]
fname, dname = os.path.abspath(fname), os.path.abspath(dname)

mapping = parse_file(fname)
transform_names(mapping,dname)
