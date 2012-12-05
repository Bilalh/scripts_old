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
        tracks = albums.pop(album,{'tracks':[],'plays':0, 'played':0,'total':"?"})
        tracks['tracks'].append((name,v))
        tracks['played'] += 1
        tracks['plays'] += v
        albums[album] = tracks
    return albums


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
            return sum([len([f for f in files if os.path.splitext(f)[-1] in music])
                            for _,_, files in os.walk(os.path.join(dname,name))])

        album["total"] = files_data(name2)
        albums[name2] = album

    for name in os.walk(dname).next()[1]:
        func(name)
    for name in os.walk(os.path.join(dname,"add")).next()[1]:
        func(name,"add")


def print_albums(albums):
    print "{:<80} {:>5} {:>8} {:^8}".format("Album", "Plays", "Played", "%")
    i = 0
    
    for (album,data) in sorted(albums.iteritems()):
        pre = "{:.3g}".format(data['played'] / (data['total']+0.001) * 100) if isinstance(data['total'], int) else "?"
        print "{0:<80} {plays:^5} {played:>4}/{total:<4} {pre:>5}%".format(
            album,
            pre=pre,
            **data)
        i += 1


def print_with_unknown_totals(albums):
    pp({k:v for (k,v) in albums.iteritems() if v['total'] == '?'})

mapping = get_mapping(ypath)
albums = get_album_data(mapping)
get_directory_data(dname,albums)

# print_with_unknown_totals(albums)
print_albums(albums)


