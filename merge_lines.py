#!/usr/bin/env python3
#-*- coding: utf-8 -*-
import logging
import argparse
# import shutil


logger = logging.getLogger(__name__)

parser = argparse.ArgumentParser(description='Merge the files, line by line ')
parser.add_argument("files", help='Files to merge', metavar='file',  nargs='+', type=argparse.FileType('r', 1) )
args = parser.parse_args()


process = True
while process:
    process = False
    for file in args.files:
        line=file.readline()
        if line:
            print(line.strip())
            process = True
