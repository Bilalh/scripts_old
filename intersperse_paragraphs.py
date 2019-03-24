#!/usr/bin/env python3

from pprint import pprint
import argparse
import fileinput
import logging

logger = logging.getLogger(__name__)


class BySpacing:
    """ Using spacing at the start of the line to split """

    def empty_line(self):
        pass

    # return True if it should go in the post array
    def line(self, text):
        return text[0].isspace()


class ByParagraph:
    """ Alt between paragraph """

    def __init__(self):
        self.post = False
        self.prev_empty = False

    def empty_line(self):
        if not self.prev_empty:
            self.post = not self.post

        self.prev_empty = True

    # return True if it should go in the post array
    def line(self, text):
        self.prev_empty = False
        return self.post


parser = argparse.ArgumentParser(description='Intersperse paragraphs')
parser.add_argument('file', nargs='?', default='-')
parser.add_argument(
    "-p --paragraph",
    help=ByParagraph.__doc__,
    action='store_true',
    dest='paragraph')
args = parser.parse_args()

if args.paragraph:
    process = ByParagraph()
else:
    process = BySpacing()

pre = []
post = []

for line in fileinput.input(args.file):
    text = line.rstrip()

    if not text:
        process.empty_line()
        continue

    if process.line(text):
        post.append(text)
    else:
        pre.append(text)

    if len(pre) == len(post):
        for p, q in zip(pre, post):
            print(p)
            print(f'  {q.strip()}')

        print()
        print()
        pre.clear()
        post.clear()
