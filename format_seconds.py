#!/usr/bin/env python3
#-*- coding: utf-8 -*-
import argparse
import math


parser = argparse.ArgumentParser()
parser.add_argument('seconds',  help= "seconds e.g  3  or 5.4 ")
args = parser.parse_args()
frac,seconds = math.modf( float(args.seconds) )

m, s = divmod(seconds, 60)
h, m = divmod(m, 60)
print("%02d:%02d:%02.03f" % (h, m, s+frac), end='')

