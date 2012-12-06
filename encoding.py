#!/usr/bin/python
# -*- coding: utf-8 -*-
import locale, os
import sys
reload(sys)
sys.setdefaultencoding("utf-8")

print(sys.stdout.encoding)
print(sys.stdout.isatty())
print(locale.getpreferredencoding())
print(sys.getfilesystemencoding())
print("Ω")