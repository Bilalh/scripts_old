#!/usr/bin/env python3
#-*- coding: utf-8 -*-
import logging
import argparse
import random

logger = logging.getLogger(__name__)

parser = argparse.ArgumentParser(description="Shuffle the numbers [low,high)")
parser.add_argument("low", help='lower bound', type=int)
parser.add_argument("high", help='upper bound', type=int)
args = parser.parse_args()

nums=list(range(args.low, args.high))
random.shuffle(nums)

for i in nums:
  print("%2d" %  (i))
