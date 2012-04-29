#!/usr/bin/env ruby19
# englify (converts the artist name to english if posible)

require "englify"

(puts "#{File.basename $0} artist name"; exit) if ARGV.length ==0

puts englify(ARGV[0])