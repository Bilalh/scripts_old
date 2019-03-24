#!/usr/bin/env python3
#-*- coding: utf-8 -*-
import logging
import argparse
# import shutil

logger = logging.getLogger(__name__)

parser = argparse.ArgumentParser(description='Merge the files, line by line ')
parser.add_argument(
    "files",
    help='Files to merge',
    metavar='file',
    nargs='+',
    type=argparse.FileType('r', 1))
parser.add_argument(
    "--indent",
    help='Indent to add on all files but the first if specified',
    metavar='indent')
args = parser.parse_args()

process = True
while process:
    process = False
    for (i, file) in enumerate(args.files):
        line = file.readline()
        if line:
            if args.indent and i != 0:
                print(args.indent, end="")
            print(line.rstrip())
            process = True
