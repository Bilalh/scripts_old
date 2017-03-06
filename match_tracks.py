#!/usr/bin/env python3
#-*- coding: utf-8 -*-
import logging
import reprlib
import bisect
import textwrap

from pprint import pprint
from pathlib import Path

logger = logging.getLogger(__name__)

def parse_args():
    import argparse
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter,
        description=textwrap.dedent("""
            Output a list of possible matches for tracks from `smaller` in `main``

            Files should have the format
                <NUM> <NAME> <TIME>
            e.g.
                03 Droplets of Time 0:10

            Uses the time and levenshtein distance.
        """))
    parser.add_argument("main", help='main file for lookup')
    parser.add_argument("smaller", help='files with tracks to match')
    parser.add_argument("-l", "--limit", help='Limit for time matching'
        , default=10, type=int)
    args = parser.parse_args()
    return args

args = parse_args()
main_fp = Path(args.main).expanduser()
plus_fp = Path(args.smaller).expanduser()
limit = args.limit

class Record(object):
  """ Parse the data of a track """
  def __init__(self, line):
    super(Record, self).__init__()
    self.process(line)

  def process(self, line):
    line = line.strip()
    [num, *name, time] = line.split()

    self.num = int(num)
    self.name = " ".join(name)
    self.time = sum(int(t) * (60 ** i) for i, t in enumerate(reversed(time.split(":"))))
    self.time_s = time

  def __repr__(self):
    try:
      items = ("%s = %r" % (k, v) for k, v in self.__dict__.items())
      return "<%s: {%s}." % (self.__class__.__name__, ', '.join(items))
    except AttributeError:
      return repr(self)


def levenshtein(s, t):
    ''' From Wikipedia article; Iterative with two matrix rows. '''
    if s == t: return 0
    elif len(s) == 0: return len(t)
    elif len(t) == 0: return len(s)
    v0 = [None] * (len(t) + 1)
    v1 = [None] * (len(t) + 1)
    for i in range(len(v0)):
      v0[i] = i
    for i in range(len(s)):
      v1[0] = i + 1
      for j in range(len(t)):
        cost = 0 if s[i] == t[j] else 1
        v1[j + 1] = min(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost)
      for j in range(len(v0)):
        v0[j] = v1[j]

    return v1[len(t)]


main = []
plus = []

for line in main_fp.open():
  r = Record(line)
  main.append(r)

for line in plus_fp.open():
  r = Record(line)
  plus.append(r)

matches = []

main = sorted(main, key=lambda r: r.time)
main_times = [r.time for r in main]


for row in plus:
  ix = bisect.bisect_right(main_times, row.time - limit)
  possible = []
  while (main[ix].time <= row.time + limit):
    l=levenshtein(row.name, main[ix].name)
    possible.append( (l, main[ix]) )
    ix += 1

  possible = sorted(possible, key=lambda r: (r[0], r[1].name) )
  matches.append((row, possible))

# pprint(matches)

for row,possible in matches:
    print(row)
    print("%4s %3s %3s %5s %s" % ("", "L", "#", "Time", "Name") )
    for (score,match) in possible:
        print("%4s %3d %3d %5s %s" % ("", score, match.num, match.time_s, match.name))



