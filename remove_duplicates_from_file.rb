#!/usr/bin/env ruby -wKU
# encoding: UTF-8

(puts "#{File.basename $0} filename\nPrints the file without the duplicates lines"; exit) unless ARGV.length == 1

lines = IO.read(File.expand_path ARGV[0]).split "\n"

dups = {}
dups.default=-1
lines.inject(dups) { |h,v| h[v]=h[v].to_i+1; h }.reject! { |k,v|  v == 0   }

a = lines.reject! do |e|
	if dups.has_key? e then
		dups[e] -= 1
		dups.delete e  if dups[e] == 0
		true
	else 
		false
	end
end

puts lines