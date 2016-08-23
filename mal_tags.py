#!/usr/bin/env python3
#-*- coding: utf-8 -*-
# Parses MAL and output the themes in the required form
# Requires BeautifulSoup & requests

import logging
import argparse
import enum
import re
import datetime
import sys

from operator import itemgetter

import requests
from bs4 import BeautifulSoup

logger = logging.getLogger(__name__)
logger_level = logging.WARNING
logger_format = '%(name)s:%(lineno)d:%(funcName)s: %(message)s'
logging.basicConfig(format=logger_format, level=logger_level)

# extract infomation from the title
theme_regex = re.compile(
    r"""
    (?:\#(?P<number>\d+):?)?         # Theme Number
    \s*"(?P<title_>(?P<title>.*?)   # Title
                                    # JPN title
    (?:\s*\((?P<title_jp>[\u3000-\u303f\u3040-\u309f\u30a0-\u30ff
                       \uff00-\uff9f\u4e00-\u9faf\u3400-\u4dbf].*)\))?
        )"

    (?: # Artist and Ep numbers
      \s*(?:by\s(?P<artist>.*?))\s*(?:\(eps?\s?(?P<eps>.*)\))
    |   # Artist
      \s*(?:by\s(?P<artist_only>.*))
    |   # Ep numbers
      \s*(?:\(eps?\s?(?P<eps_only>.*)\))
    |
    )
    (?P<rest>.*)
    """, re.VERBOSE)  # yapf: disable

# If the title does not have a closeing "
# We try a simpler regex to get some infomation
theme_regex_missing_quote = re.compile(
    r"""
    (?:\#(?P<number>\d+):?)?         # Theme Number
    \s*"(?P<title_>(?P<title>.*)    # Title
        )"?
    \s*(?:by\s(?P<artist>.*))?      # Artist
    \s*(?:\(eps?\s?(?P<eps>.*)\))?  # Ep numbers
    (?P<rest>.*)
    """, re.VERBOSE)

tag_values = {
    "OP": 0,
    "ED": 0,
    "NC": 2,
    "VHS": 4,
    "DVD": 4,
    "BD": 4,
    "VN": 4,
    "360": 6,
    "396": 6,
    "474": 6,
    "476": 6,
    "478": 6,
    "480": 6,
    "576": 6,
    "600": 6,
    "624": 6,
    "720": 6,
    "1080": 6,
    "Trans": 8,
    "Over": 10,
    "RC": 12,
    "Lyrics": 14,
    "Subbed": 16,
    "Spoiler": 20,
}
# Convert the lower case tag to the correct formatting
tags_map = {k.lower(): k for k in tag_values.keys()}


@enum.unique
class Kind(enum.Enum):
  op = "OP"
  ed = "ED"


# Parses and stores a theme
class Theme:
  def __init__(self, text, kind):
    super(Theme, self).__init__()
    self.kind = kind
    self._parse(text)

  def tag(self):
    return '[{}]'.format(self.kind.value)

  def variant(self):
    num_part = ""
    if (self.kind == Kind.op and len(openings) > 1) or (self.kind == Kind.ed and len(
            endings) > 1):
      num_part = str(self.number)

    return "{}{}".format(self.kind.value, num_part)

  def _parse(self, text):
    logger.info(text)

    matcher = theme_regex
    if text.count('"') == 1:
      if text[0] != '"':
        text = '"' + text
      else:
        matcher = theme_regex_missing_quote

    match = matcher.match(text)
    fields = match.groupdict()

    logger.info(match)
    logger.info(match.groupdict())

    if fields['number'] is not None:
      self.number = int(fields['number'])
    else:
      self.number = 1

    self.title = fields['title']
    self.eps = fields['eps'] or fields['eps_only'] or ""
    self.artist = fields['artist'] or fields['artist_only'] or ""


def parse_args():
  parser = argparse.ArgumentParser()
  parser.add_argument("term", help='mal url/id')
  parser.add_argument('-s --search',
                      action='store_true',
                      dest='search',
                      help='Find id by name')
  parser.add_argument(
      '-t --table',
      action='store_true',
      dest='table',
      help=
      'Output the series as a nicely formatted markdown table. Requires the tabulate module')
  parser.add_argument('-u --ugly',
                      action='store_true',
                      dest='ugly_table',
                      help='Output series as a minimal markdown table e.g. for reddit')
  parser.add_argument('tags',
                      nargs='*',
                      choices=sorted(v for v in (tags_map.keys() - {"op", "ed"})),
                      help='tags to add without []',
                      metavar='tags')
  return parser.parse_args()
  # return argparse.Namespace(
  #     url="http://myanimelist.net/anime/30911/Tales_of_Zestiria_the_X",
  #     tags=['nc', 'bd', '720'])


def get_url(args):
  term = args.term
  if not args.search:
    if term.startswith('myanimelist.net'):
      term = "http://" + term
    if re.fullmatch(r"\d+", term):
      term = "http://myanimelist.net/anime/{}".format(term)

    if not re.fullmatch(r"http://myanimelist.net/anime/\d+/?(/.*)?", term):
      print("invaild url {}".format(term))
      sys.exit(2)

    return term

  # search all
  # search_url = "http://myanimelist.net/search/all"
  # page = requests.get(search_url, params={"q": term})
  # soup = BeautifulSoup(page.content, "html.parser")
  # anime_url = soup.select_one('article > div').select_one('a.hoverinfo_trigger')['href']

  search_url = "http://myanimelist.net/anime.php"
  page = requests.get(search_url, params={"q": term})
  soup = BeautifulSoup(page.content, "html.parser")
  anime_url = soup.select_one('a.hoverinfo_trigger')['href']
  print("    ", anime_url)
  return anime_url


args = parse_args()
logger.info(args)
url = get_url(args)
anime_id = int(re.match(r"http://myanimelist.net/anime/(\d+)", url).group(1))

page = requests.get(url)
soup = BeautifulSoup(page.content, 'html.parser')

try:
  anime = soup.select_one('.h1 > span').text
except AttributeError:
  logger.error(soup)
  sys.exit(1)


def get_season(soup):
  premiered = soup.find(text="Premiered:")
  if premiered:
    return premiered.parent.parent.find('a').text
  else:  # no season so calculate it outself
    aired = soup.find(text="Aired:")
    if aired:
      date_text = aired.next_element.strip()
      logger.info("aired %s", date_text)
      date_text = date_text.split("to")[0].strip()
      date = datetime.datetime.strptime(date_text, "%b %d, %Y")
      logger.info("aired date %s", date)

      part = ""
      if date.month <= 3:
        part = "Winter"
      elif date.month <= 6:
        part = "Spring"
      elif date.month <= 9:
        part = "Summer"
      elif date.month <= 12:
        part = "Fall"

      return "{} {}".format(part, date.year)

  return ""


def get_other_titles(soup):
  other_titles = []
  english = soup.find(text="English:")
  if english:
    other_titles += english.next_element.strip().split(',')

  synonyms = soup.find(text="Synonyms:")
  if synonyms:
    other_titles += synonyms.next_element.strip().split(',')

  return other_titles


season = get_season(soup)
other_titles = get_other_titles(soup)

mapping = dict(anime=anime, season=season, other_titles=other_titles)
openings = []
endings = []

valued_tags = [(tags_map[t], tag_values[tags_map[t]]) for t in args.tags]
tags = [k for (k, _) in sorted(valued_tags, key=itemgetter(1))]
mapping['tags'] = tags
mapping['tags_str'] = "".join("[{}]".format(s) for s in tags)
mapping['tags_comma'] = ", ".join([t for t in tags if t != '720'])

logger.info(mapping)

for op in soup.select('.opnening .theme-song'):
  openings.append(Theme(op.text, Kind.op))

for ed in soup.select('.ending .theme-song'):
  endings.append(Theme(ed.text, Kind.ed))


def print_individual(data, themes):
  for theme in themes:
    print('{anime} ({season}) - {variant} - "{title}" {tag}{tags_str}'.format(
        variant=theme.variant(),
        title=theme.title,
        tag=theme.tag(),
        **
        mapping))


def print_as_table_formatted(data, themes):
  from tabulate import tabulate
  headers = ['Theme title', 'Links', 'Episodes', "Artist", 'Notes']
  rows = []

  print('{anime} ({season}) {tags_str}'.format(**data))
  print()
  print("###[{}]({})".format(data['anime'], url))
  print("**" + ", ".join(data['other_titles']) + "**")
  print()
  for theme in themes:
    rows.append(['{} "{}"'.format(theme.variant(), theme.title), "[Webm \({})]()".format(
        data['tags_comma']), theme.eps, theme.artist, ""])
  print(tabulate(rows, headers=headers, tablefmt="pipe"))
  print()


def print_as_table_ugly(data, themes):
  print('{anime} ({season}) {tags_str}'.format(**data))
  print("")
  print("###[{}]({})".format(data['anime'], url))
  print("**" + ", ".join(data['other_titles']) + "**")
  print()
  print("Theme title|Links|Episodes|Notes")
  print("-|:-:|:-:|:-:|:-:|:-:")
  rows = []
  for theme in themes:
    rows.append(['{} "{}"'.format(theme.variant(), theme.title), "[Webm \({})]()".format(
        data['tags_comma']), theme.eps, ""])

  for row in rows:
    print(*row, sep="|")

  print("")


if args.table:
  print_as_table_formatted(mapping, openings + endings)
elif args.ugly_table:
  print_as_table_ugly(mapping, openings + endings)
else:
  print("     mal_tags.py -u {} {}".format(anime_id, " ".join(t.lower() for t in tags)))
  print_individual(mapping, openings + endings)
