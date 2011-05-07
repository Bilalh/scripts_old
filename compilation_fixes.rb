#!/usr/bin/env ruby
# Bilal Hussain

require "rubygems"
require "mp3info"

(puts "compilation_fixes.rb glob"; exit) unless ARGV.length == 1 

Dir.glob(ARGV[0]).each_with_index do |file,i|
	Mp3Info.open(file) do |meta|
		
		meta.tag.title = 
			meta.tag.title.gsub(/ ?\(TV Version?\) ?/i, "")
		puts meta.tag.title
		puts meta.tag.tracknum  = i+1
		
		full = meta.tag2.COMM[/(op|ed)( ?\d+)?/i]
		short = meta.tag2.COMM[/(op|ed)/i]
	
		extra =""
		if full and short then
			extra << " #{short.downcase},"
			extra << " #{full.gsub(/ /, '').downcase}," if full.length != short.length
		end
		
		puts meta.tag2.TIT1 = "_Lyrics," + extra  + " xs, zmain,"
		puts
		
	end	
end

