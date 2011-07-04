#!/usr/bin/env ruby19 -KU
# encoding: UTF-8
require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'htmlentities'


class Vg


	def initialize()
		@names = {
			'en'       => :@english,
			'ja'       => :@japanese,
			'ja-Latn'  => :@romaji,
			'English'  => :@english,
			'Japanese' => :@japanese,
			'Romaji'   => :@romaji,
		}
	end
	
	def get_data(url)
		doc = Nokogiri::HTML(open(url).read)
		hash = {}
		# get_titles(doc,hash)
		get_tracks(doc,hash)
		return hash
	end
	
	def get_titles(doc, hash)
		puts "Getting Titles"
		titles ={}
		doc.css('h1 > span.albumtitle').each do |ele|
			titles[@names[ele['lang']]] = ele.text.sub ' / ', ""
			puts 	titles[@names[ele['lang']]]
		end
		hash[:title] = titles
		
		puts
	end
	
	def get_tracks(doc, hash)
		coder = HTMLEntities.new
		
		puts "Getting Tracks"
		# Gets the id of each language
		
		refs = []
		doc.css('ul#tlnav>li>a').each do |ele|
			refs << {lang: @names[ele.text], ref:ele['rel'] }
		end
		puts "refs:"
		puts refs
		
		tracks = {}
				
		refs.each do |ref|
			disc_tables = doc.css("span##{ref[:ref]}>table")
			num_discs = disc_tables.length
			hash[:total_discs] = num_discs
			puts "Getting #{ref[:lang]} tracks, #{num_discs} Discs"
			
			disc_tables.each_with_index do |disc,disc_index|
				disc_num = disc_index + 1;
				puts "disc #{disc_num}"
				disc.css('tr').each do |track_tr|
					num = track_tr.children[0].text.to_i(10)
					
					# gets the track
					track = 
					if tracks.include? "#{disc_num}-#{num}" then
						tracks["#{disc_num}-#{num}"]
					else 
						track                        = Track.new
						track.track_num              = num
						track.disc_num               = num_discs
						track.total_discs            = num_discs
						track.time                   = track_tr.children[4].text
						tracks["#{disc_num}-#{num}"] = track
					end
					
					track.instance_variable_set(ref[:lang], coder.decode(track_tr.children[2].text))
					
					p track
					# break
				end
				
				puts
			end
			
		end
		
		hash[:tracks]= tracks;
		puts
	end #get_tracks
	
end

class Track
	attr_accessor :engish, :japanese, :romaji, :track_num, :disc_num, :total_discs, :time
		
end


#url = "http://vgmdb.net/album/13192"
url = File.expand_path("~/Desktop/test.html")
vg = Vg.new()
hash = vg.get_data(url)
puts "Data"
hash.each_pair do |name, val|
	puts "#{name} => #{val}"
end



