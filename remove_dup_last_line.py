#!/usr/bin/env python3
#-*- coding: utf-8 -*-
import sys

last=None
for line in sys.stdin:
    if last is None or line != last:
      print(line.strip())
    last = line
