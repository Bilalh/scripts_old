#!/usr/bin/env ruby19
#Removes the specified elements using css and/or xpath

require 'nokogiri'
require 'fileutils'

if ARGV.length == 0 then
	puts "#{File.basename $0} html {css|xpath}*"
	puts "Removes the specified elements using css and/or xpath"
end

doc   = Nokogiri::HTML(open(ARGV[0]))
ARGV[1..-1].each do |ele|
	doc.search(ele).each { |e|  e.unlink }
end

File.open(ARGV[0], 'w') do |f|  
	f.write doc.to_xml
end