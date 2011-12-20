#!/usr/bin/env ruby
# encoding: utf-8
# Bilal Hussain

# Set the comment fields to the album 

require "rubygems"
require "mp3info"

(puts "album_to_comment.rb glob"; exit) unless ARGV.length == 1 

Dir.glob(ARGV[0]).each do |file|
	Mp3Info.open(file) do |meta|
		meta.tag2.COMM = meta.tag.album
	end	
end