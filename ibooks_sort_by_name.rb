#!/usr/bin/env ruby19 -wKU
# Sorts  a collection by name
# Bilal  Hussain

(puts "#{File.basename $0} Collection Z_PK [iBooks sqlite]"; exit) if ARGV.length != 1 && ARGV.length != 2

collectionId = ARGV[0]

db = if ARGV.length == 2 then 
			ARGV[1] 
		else 
			File.expand_path("~/Desktop/iBooks_v10252011_2152.sqlite")
		end

require 'sqlite3'
require "pp"

IBooksDB = File.expand_path("~/Desktop/iBooks_v10252011_2152.sqlite")

db = SQLite3::Database.new( IBooksDB )
#db.results_as_hash = true;

query = <<-SQL
Select  b.Z_PK, b.ZSORTTITLE ,b.ZSORTKEY
from ZBKCOLLECTIONMEMBER c
Join ZBKBOOKINFO  b on c.ZDATABASEKEY = b.ZDATABASEKEY
Join ZBKCOLLECTION cc on cc.Z_PK = c.ZCOLLECTION
where cc.Z_PK='#{collectionId}'
Order by c.ZCOLLECTION, b.ZSORTTITLE
SQL

results = db.execute( query )

# Get the sort keys highest first
numbers  = results.collect do |e|
	e[2]
end.sort.reverse

# pp numbers

# set the sort keys
results.each_with_index do |e, i|
	e[2]= numbers[i]
end

puts
pp results

results.each do |e|
	puts db.execute(
		"Update ZBKBOOKINFO
		 Set ZSORTKEY = #{e[2]}
		 where Z_PK   = #{e[0]}"
	)
end