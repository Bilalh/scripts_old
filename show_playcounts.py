#!/usr/bin/python
# -*- coding: utf-8 -*-
from __future__ import division
import sys
reload(sys)
sys.setdefaultencoding("utf-8")

import os
import re
from pprint import pprint as pp
import yaml
import codecs

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

ypath = "/Users/bilalh/Music/playcount.yaml"
dname = "/Users/bilalh/Movies/add"


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
    def func(name,base=None):
        if name == "add": return
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
        album["pre"] = album['played'] / (album['total']+0.001) * 100
        albums[name2] = album

    for name in os.walk(dname).next()[1]:
        func(name)
    for name in os.walk(os.path.join(dname,"add")).next()[1]:
        func(name,"add")


def print_albums(albums,key=None,reverse=False):
    from operator import itemgetter, attrgetter
    print "{:<90} {:>5} {:>8} {:^10} {:^15}".format("Album", "Plays", "Played", "%","Created")
    i = 0
    
    for (album,data) in sorted(albums.iteritems(),key=key,reverse=reverse):
        print "{0:<90} {plays:^5} {played:>4}/{total:<4} {pre:>5.3g}% {date}".format(
            album,
            **data)
        i += 1


def print_with_unknown_totals(albums):
    pp({k:v for (k,v) in albums.iteritems() if v['total'] == '?'})

mapping = get_mapping(ypath)
albums = get_album_data(mapping)
get_directory_data(dname,albums)

# print_with_unknown_totals(albums)
print_albums(albums)
print_albums(albums,lambda (x,y): y['plays'],True)

