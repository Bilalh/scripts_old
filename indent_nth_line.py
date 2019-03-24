#!/usr/bin/env python3

from pprint import pprint
import argparse
import fileinput
import logging

logger = logging.getLogger(__name__)
logger_level = logging.INFO
logger_format = '%(name)s:%(lineno)d:%(funcName)s: %(message)s'
logging.basicConfig(format=logger_format, level=logger_level)

parser = argparse.ArgumentParser(
    description='Indent every nth line',
    formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('file', nargs='?', default='-')
parser.add_argument(
    '--ws', dest='whitespace', action='store_false', help='Skip blank lines')
parser.add_argument("-n", type=int, help='n to use', default=2)
parser.add_argument(
    "-t", type=int, help='total to use default -n', default=None)

parser.add_argument(
    "--indent",
    metavar='str',
    help='Indent to add on all files but the first if specified',
    default='  ')
args = parser.parse_args()

if args.t is None:
    args.t = args.n

i = 0
for line in fileinput.input(args.file):
    text = line.strip()
    logger.debug(f"{i}--{text}--")

    if text:
        i += 1
    print(f"{args.indent * (args.n == i) }{text}")

    if i == args.t:
        i = 0