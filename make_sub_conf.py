#!/usr/bin/env python3
#-*- coding: utf-8 -*-
import logging

from pprint import pprint
from pathlib import Path

logger = logging.getLogger(__name__)

for ext in ["*.mkv", "*.mp4", "*.webm", "*.avi"]:
    for mkv in Path.cwd().glob(ext):
        conf = mkv.with_suffix(".mkv.conf")
        with conf.open('w') as f:
            f.write("sub-file={}\n".format(mkv.name))
