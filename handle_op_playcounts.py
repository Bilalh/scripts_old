#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import division
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

"""
Adds the playcounts of the op file using the data file to iTunes
"""

import os
from pprint import pprint as pp
import yaml
import codecs
import subprocess

OP_PATH = '/Users/bilalh/Music/op_playcount.yaml'
LOOKUP_PATH = '/Users/bilalh/Programming/Files/_metadata.yaml'


def get_mapping(path):
    f = codecs.open(path, encoding='utf-8')
    return yaml.load(f)


def convertToTuple(metadata):
    #pp (metadata)
    return (metadata[":album"], metadata[":title"], metadata[":artist"],metadata[":track"], metadata[":disc"])


def handle_dups(tuples):
    data = {}
    for (name, num) in tuples:
        if name in data:
            data[name] += [num]
        else:
            data[name] = [num]

    return data


def combine_op_and_data(op, mapping):
    hasMapping = [(convertToTuple(mapping[k]), (k,v)) for (k, v) in op.iteritems() if k in mapping]
    return handle_dups(hasMapping)


def increment_playcounts(mapping):
    not_done = []
    not_done_files = []
    for (k,counts) in mapping.iteritems():
        (album,title,artist,track,disc) = k
        count = sum([i for (_,i) in counts])
        # print(["/usr/local/bin/increment_playcount.applescript",album,str(track),str(disc),str(count)])
        code = subprocess.call(["/usr/local/bin/increment_playcount.applescript",album,str(track),str(disc),str(count)])
        if code == 1:
            not_done += [{":album": album, ":title": title, ":artist":artist, ":track":track, ":disc": disc}]
            not_done_files += [dict(counts)]
    return (not_done, not_done_files)

op = get_mapping(OP_PATH)
mapping = get_mapping(LOOKUP_PATH)


results = combine_op_and_data(op, mapping)
# pp(results)

(not_done, not_done_files) = increment_playcounts(results)

with open('/Users/bilalh/Music/not_done_data.yaml',"w") as f:
    f.write(yaml.dump(not_done))

with open('/Users/bilalh/Music/op_playcount_new.yaml',"w") as f:
    f.write(yaml.dump(not_done_files))



# debuging stuffs

def iter_many(it, length, num):
    for i in xrange(0, length, num):
        yield (it[i:i + num])


def get_track_and_disc_number(album, title, artist):
    (_,rout) = os.popen2("""'/Users/bilalh/Projects/ Utilities/Scripts/get_track_and_disk.applescript'\
        "%s" "%s" "%s"
        """ % (album, title, artist))
    data = rout.readline().strip()
    if not data: return []
    arr = [ele.strip() for ele in data.split(",")]

    res = []
    for trackS, discS, time in iter_many(arr, len(arr), 3):
        (track, disc) = int(trackS), int(discS)
        res.append({"track": track, "disc": disc, "time": time})

    return res


def add_track_numbers(mapping):
    for (k,v) in mapping.iteritems():
        if not ':album' in v : continue
        info = get_track_and_disc_number(v[':album'],v[':title'],v[':artist'])
        pp(k)
        pp(info)

        del v[':album']
        del v[':title']
        del v[':artist']

        if len(info) == 1:
            info = info[0]
            v = {}
            v[":disc"] = info["disc"]
            v[":track"] = info["track"]
        else:
            if len(info): v[':z'] = info



# add_track_numbers(mapping)
# with open('/Users/bilalh/Music/op_new.yaml',"w") as f:
#     f.write(yaml.dump(mapping))

