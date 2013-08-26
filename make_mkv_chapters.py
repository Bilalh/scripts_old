#!/usr/bin/python
# -*- coding: utf-8 -*-
# Bilal Syed Hussain

import sys
import os
from pprint import pprint as pp
from string import Template
 
# sys.argv = ["","/Users/bilalh/chapters.txt"]
if len(sys.argv) != 2:
    print "{} chapter_file".format(os.path.basename(sys.argv[0]))
    print """Parses  HH:MM:SS text """
    sys.exit()

chapters_file = sys.argv[1]


def parse(line):
    """Parses  HH:MM:SS text  -> (time,text)"""
    parts = line.strip().split(" ")
    return (parts[0], " ".join(parts[1:]) )

with open(chapters_file) as f:
    data = [ parse(line) for line in f if line != "\n"]


def make_chapter_xml((time,name)):
    """ Creates the xml for the chapter """
    chapter = Template("""
    <ChapterAtom>
      <ChapterTimeStart>$time</ChapterTimeStart>
      <ChapterDisplay>
        <ChapterString>$name</ChapterString>
        <ChapterLanguage>eng</ChapterLanguage>
      </ChapterDisplay>
    </ChapterAtom>""")
    return chapter.substitute(time=time,name=name)

chapters = [ make_chapter_xml(ts) for ts in data ]


xml = """<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE Chapters SYSTEM "matroskachapters.dtd">

<Chapters>
  <EditionEntry>
  {chapters}
  </EditionEntry>
</Chapters>
""".format(chapters="\n".join(chapters))

print xml





