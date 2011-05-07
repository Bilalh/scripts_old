#!/usr/bin/env ruby19
# encoding: UTF-8

# Aigns equals signs in many languages requires ruby 1.9  

def alternation(*s); s.map(&Regexp.method(:escape)).join("|") end

# All input is read here.
LINES        = $stdin.readlines

# ASSIGNMENT_OPERATORS: for C, ruby, perl, python, javascript, java, even pascal. Hash assignment included too.
# TROUBLEMAKERS: non-assignment operators that could match as assigment.
ASSIGNMENT_OPERATORS = %w( = -= += /= //= %= *= **= ^= |= &= ||= &&= <<= >>= >>>= .= x= := ::= => )
TROUBLEMAKERS        = %w( <= >= <=> == === != =~ )
TROUBLEMAKERS_BEFORE = TROUBLEMAKERS.map { |s| s[/^(.+)=/, 1] }.compact.uniq
TROUBLEMAKERS_AFTER  = TROUBLEMAKERS.map { |s| s[/=(.+)$/, 1] }.compact.uniq

# Magic happens here.
RX_ASSIGNMENT_LINE   = %r[
(^.*?) # capture 1 — everything before assignment
( \s* # capture 2 — assignment operator with surrounding spaces
(?<! #{alternation(*TROUBLEMAKERS_BEFORE)} )
( (?: #{alternation(*ASSIGNMENT_OPERATORS)} ) # capture 3 — assignment operator
| :(?!\w|:) ) # special handling for the ':' assignment op (yaml, javascript, etc)
(?! #{alternation(*TROUBLEMAKERS_AFTER )} )
\s* )
]x

l0, lf = [0, LINES.length.pred]

match_lines  = LINES[l0..lf].map { |s| [s.match(RX_ASSIGNMENT_LINE), s] }.select { |m, s| m }
len_leftside = match_lines.map { |m, s| m.begin(2) }.max
len_operator = match_lines.map { |m, s| m[3].length }.max

match_lines.each { |m, s| s.replace [m[1].ljust(len_leftside), m[3].rjust(len_operator), m.post_match].join(" ") }
print LINES.join ''

