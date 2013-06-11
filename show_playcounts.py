#!/usr/bin/python
# -*- coding: utf-8 -*-

"""
Shows the stats about audio files that have been played
"""

from __future__ import division
import sys
reload(sys)
sys.setdefaultencoding("utf-8")

import os
import re
from pprint import pprint as pp
import yaml
import codecs

# from so
from ctypes import *


class struct_timespec(Structure):
    _fields_ = [('tv_sec', c_long), ('tv_nsec', c_long)]


class struct_stat64(Structure):
    _fields_ = [
        ('st_dev', c_int32),
        ('st_mode', c_uint16),
        ('st_nlink', c_uint16),
        ('st_ino', c_uint64),
        ('st_uid', c_uint32),
        ('st_gid', c_uint32),
        ('st_rdev', c_int32),
        ('st_atimespec', struct_timespec),
        ('st_mtimespec', struct_timespec),
        ('st_ctimespec', struct_timespec),
        ('st_birthtimespec', struct_timespec),
        ('dont_care', c_uint64 * 8)
    ]

libc = CDLL('libc.dylib')
stat64 = libc.stat64
stat64.argtypes = [c_char_p, POINTER(struct_stat64)]


def get_creation_time(path):
    buf = struct_stat64()
    rv = stat64(path, pointer(buf))
    if rv != 0:
        raise OSError("Couldn't stat file %r" % path)
    return buf.st_birthtimespec.tv_sec
##


def get_mapping(path):
    f = codecs.open(path, encoding='utf-8')

    mapping = yaml.load(f)
    remove = re.compile(r"/Users/bilalh/Movies/add//?")

    return {remove.sub("",k):v for (k,v) in mapping.iteritems()}


def get_album_data(mapping):
    albums = {}
    for (k,v) in mapping.iteritems():
        if not v:
            v = 1
        album,name = os.path.split(k)
        (shead,_) = os.path.split(album)
        if shead and shead != 'add':
            album = shead
        tracks = albums.pop(album,{'tracks':[],'plays':0, 'played':0,'total':"?","date":"","pre":-1})
        tracks['tracks'].append((name,v))
        tracks['played'] += 1
        tracks['plays'] += v
        albums[album] = tracks
    return albums


def fromat_time(unix_time):
    import datetime
    return datetime.datetime.fromtimestamp(unix_time).strftime('%Y-%m-%d %a %d %b')


def get_directory_data(dname,albums):
    def func(name, base = None):
        if name == "add" or name == "zoff": return
        if base:
            name2 = os.path.join("add",name)
        else:
            name2 = name
        album = albums.pop(name2, {'tracks':[],'plays':0, 'played':0})
        music = {".mp3", ".m4a", ".flac"}

        def files_data(name):
            path = os.path.join(dname,name)
            return sum([len([f for f in files if os.path.splitext(f)[-1] in music])
                            for _,_, files in os.walk(os.path.join(dname,name))])

        album["total"] = files_data(name2)
        album["date"] = fromat_time(get_creation_time(os.path.join(dname,name2)))
        update_precent_and_ratio(album)
        albums[name2] = album

    for name in os.walk(dname).next()[1]:
        func(name)
    for name in os.walk(os.path.join(dname,"add")).next()[1]:
        func(name,"add")


def update_precent_and_ratio(album):
    album["pre"] = album['played'] / (album['total'] + 0.001) * 100
    album["ratio"] = album["plays"] / album["total"]


def print_albums(albums,key=None,reverse=False):
    print "{:<90} {:>5} {:>8} {:^10} {:<4} {:^15}".format("Album", "Plays", "Played", "%","R", "Created")
    i = 0
    for (album,data) in sorted(albums.iteritems(),key=key,reverse=reverse):
        print "{0:<90} {plays:^5} {played:>4}/{total:<4} {pre:>5.3g}% {ratio:4.1f}x {date}".format(
            album,
            **data)
        i += 1


def unknown_totals(albums):
    return {k:v for (k,v) in albums.iteritems() if v['total'] == '?'}


def convert_or_delete_unknown(albums):
    unkown = unknown_totals(albums)
    for key in unkown.iterkeys():
        del albums[key]

    for (k,v) in unkown.iteritems():
        k2 = "add/" + k
        if k2 in albums:
            v2 = albums[k2]

            v2["plays"] += v["plays"]

            vt = dict(v2["tracks"])
            for (track, num) in v['tracks']:
                if track in vt:
                    vt[track] += num
                else:
                    vt[track] = num
            v2["tracks"] = vt.items()
            assert v2["total"] == "?" or len(v2["tracks"]) <= v2["total"]
            assert len(v2["tracks"]) >= v2["played"]

            v2["played"] = len(v2["tracks"])
            update_precent_and_ratio(v2)
    return None


def write_single_album(albums,name):
    data = {k:v for (k,v) in albums.iteritems() if k == name}
    res = {}
    for (album,v) in data.iteritems():
        for (name,count) in v['tracks']:
            res[os.path.join('/Users/bilalh/Movies/add',album,name)] = count

    with open('/Users/bilalh/Music/extra.yaml',"w") as f:
        f.write(yaml.dump(res))

    pp(res)

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description='Shows Playcounts of the given yaml data file')
    parser.add_argument('-p','--plays',  dest='selected', action='store_const', const='plays',   help='Sort by plays')
    parser.add_argument('-n','--name',   dest='selected', action='store_const', const='name',    help='Sort by Name (default)')
    parser.add_argument('-%','--precent',dest='selected', action='store_const', const='precent', help='Sort by precent played')
    parser.add_argument('-l','--played', dest='selected', action='store_const', const='played',  help='Sort by amount played')
    parser.add_argument('-t','--total',  dest='selected', action='store_const', const='total',   help='Sort by total tracks')
    parser.add_argument('-m','--ratio',  dest='selected', action='store_const', const='ratio',   help='Sort by ratio')
    parser.add_argument('-d','--date',   dest='selected', action='store_const', const='date',    help='Sort by date created')

    parser.add_argument('-r','--reverse',dest='rev', action='store_true', help='Reverse Sort')

    args = parser.parse_args()

    # Negate the boolean if reverse is selected.
    func = lambda (x,y): (x,y)
    if args.rev:
        func = lambda (x,y): (x,not y)

    selected = args.selected
    sorter = {
        'plays':   (lambda (x,y): (y['plays'],x),True),
        'played':  (lambda (x,y): (y['played'],x),True),
        'total':   (lambda (x,y): (y['total'],x),True),
        'date':    (lambda (x,y): (y['date'],x),False),
        'precent': (lambda (x,y): (round(y['pre']),x),True),
        'ratio':   (lambda (x,y): (round(y['ratio'],1),x),True),
        'name': (None,False),
        None: (None,False)
    }

    ypath = "/Users/bilalh/Music/playcount.yaml"
    dname = "/Users/bilalh/Movies/add"

    mapping = get_mapping(ypath)
    albums = get_album_data(mapping)
    get_directory_data(dname,albums)

    # pp(unknown_totals(albums))
    # print_albums(unknown_totals(albums))
    convert_or_delete_unknown(albums)
    print_albums(albums, *func(sorter[selected]))

    want = "Madoka Movie 2 Hikari Furu"
    write_single_album(albums, want)



