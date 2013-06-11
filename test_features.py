#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import division
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

arr = [i for i in xrange(0, 99)]


def iter_many(it, length, num):
    for i in xrange(0, length, num):
        yield (arr[i:i + num])


for a, b, c in iter_many(arr, len(arr), 3):
    print (a, b, c)
