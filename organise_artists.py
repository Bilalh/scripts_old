#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import re
import sys
from pprint import pprint as pp

s = """\
Kazuki Yanagawa (1, 3, 7, 8, 10, 11)
Daisuke Achiwa (5, 9, 12)
Ken Nakagawa (2, 4, 6)
"""


def kind_m(text, type="Composer"):
	regex = r"(?<=%s:)[ \w]+" % type
	results = re.findall(regex, text)
	results = [x.strip() for x in results]
	print results


def kind_complex(text):
	r_name = re.compile(r"([\w ]+)")
	r_num = re.compile(r"(\d+)")
	mapping = {}
	lines = text.splitlines()

	for line in lines:
		name = r_name.match(line).group(0).strip()
		nums = re.findall(r_num, line)
		for n in nums:
			mapping[int(n)] = name

	return [val for (num,val) in sorted(mapping.iteritems())]

if re.search(r"M-?\d+", s):
	kind_m(s)
else:
	kind_complex(s)

# vgmdb.net/album/20427
# vgmdb.net/album/32234
# vgmdb.net/album/27827
# vgmdb.net/album/22125
# vgmdb.net/album/33201
