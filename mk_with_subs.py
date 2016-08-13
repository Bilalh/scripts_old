#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys

def f(arg):
    return  '--\{ "%s" --sub-file "%s" --\\}' % (arg, arg )

print(  " ".join(f(arg)  for arg in sys.argv[1:] ) )
