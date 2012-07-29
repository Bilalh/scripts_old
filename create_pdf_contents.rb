#!/usr/bin/env ruby19 -wKU
# Bilal Syed Hussain 
# Created the contents of a pdf as json so 
# that muplin can create the contents

# the input file level as specifed by the number of tabs
# Make need to resave the pdf to make the contents work in all pdf readers

require "pp"
require 'json'

# (puts "#{File.basename $0} text contents"; exit) if ARGV.length ==0
# filename = ARGV[0] 
filename = "/Users/bilalh/Desktop/contents.txt"

lines = File.read(filename).split "\n"
# lines = lines[0..40]
links = []

def add_last (links,last,last_level)
	links << last
end

last_level = 0
last  = nil
stack = nil
lines.each do |str|
	next if str == ""  # skip blank lines
	
  # the level is found by the number of tabs
	nested =  str.count "\t"
	
	data = str.split "...\s"
	name = data[0].strip
	# Pdf offset is one page
	num  = data[1].to_i  + 1
	
	# print  nested, " ",  last_level, "\n"
	
	if nested == 0 then 
		add_last(links,stack[0],last_level) if stack
		links << {"label"=>name, "page" => num}
		last = []
		stack = [last]
		last_level = 0
		next
	end

	#  pop/pushes to change nested level 
	# if nested == 1 then
	# 	last_level = nested
	# end 
	if nested > last_level then 
		stack.push last
		arr  =  []
		last << arr
		last =  arr
		last_level = nested
	elsif nested < last_level then
		last = stack.pop
		last_level = nested
	end
	
	if nested == last_level then
		last << {"label"=>name, "page" => num}
	end
end

pp links
# Print out contents as json 
# puts JSON.generate links