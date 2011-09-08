#!/usr/bin/env ruby -wKU
(puts "#{File.basename $0} filename\nPrints the file with pars reversed"; exit) unless ARGV.length == 1
path = ARGV[0]
# path = "~/a.txt"
file = IO.read(File.expand_path path)
file.gsub!(/\r\n?/, "\n")
lines = file.split(/\n\n/)

lines.reverse.each { |e| puts e;puts }