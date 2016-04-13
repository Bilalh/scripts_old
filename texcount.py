#!/usr/bin/env python3
#-*- coding: utf-8 -*-
import subprocess
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("filepath", help=".tex file")
args = parser.parse_args()

filepath = args.filepath
cmd = ["/Library/TeX/texbin/texcount", "-nocol", "-utf8", "-inc", "-brief", "-sum", filepath]
res = subprocess.check_output(cmd, universal_newlines=True)

lines=[]
total=0
for line in res.splitlines():
    parts = line.split(":")
    if len(parts) != 3:
        continue
    # print(parts)
    num, kind, rel = int(parts[0]), parts[1], parts[2]

    if kind == ' File(s) total':
        total="Total: {}".format(num)
    else:
        lines.append("{:_>5}:{}".format(num, rel))

print(total)
print()
print("\n".join(lines))
