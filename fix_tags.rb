#!/usr/bin/env ruby -wKU
require "rubygems"
require 'sqlite3'

BooksDB = File.expand_path("~/Desktop/books.db")

db = SQLite3::Database.new( BooksDB )

series = db.execute( 'Select name from Series s').flatten
series << '+' << 'Light Novel' << 'game' << 'Fantasy' << 'Catalog'

# Gets the tags which are not series  or allowed tags
ids = []
db.execute( 'Select name, tag_id from Tags t' ) do |row|
	
	unless series.include? row[0]
		ids << row[1]
	end
end

# remove tag
ids.each do |id|
	db.execute( 'Delete from BookTag where tag_id =?', id )
	db.execute( 'Delete from Tags where tag_id =?', id )
end

