#!/usr/bin/env ruby19 -wKU
# Bilal Syed Hussain
# encoding: utf-8

# Update BookCrawler db from Delicious Library 2's csv

require 'sqlite3'
require "csv"
require "pp"

DB        = File.expand_path "~/Desktop/Crawler.sqlite"
csv_file  = File.expand_path "~/dl.csv"

db = SQLite3::Database.new( DB )
db.results_as_hash = true

# = for title does not work for some reason
Query =<<-SQL
Select  
	date('2001-01-01','+' || be.ZCUSTOMDATE || ' second') as RealDate, ZCUSTOMDATE,
	ZISBN, ZISBN13,
	ZTITLE, ZSERIES,
	ZGENRE, ZFORMAT,
	ZPRICE, 
	ZWasRead, ZDateRead,
	ZOWN
	
from ZBOOKEDITION be 
join ZBOOK b on b.ZMAINEDITION = be.Z_PK
where b.ZTITLE like ? or be.ZISBN == ? or be.ZISBN like ? or be.ZISBN13 == ?
SQL


def find_missing(db,file)
	missing = []
	CSV.foreach(file, headers:true ) do |row|
	  # stmt.bind_params( row['title'],row['i.s.b.n.'],row['i.s.b.n.'])
		title = row['title'].to_s.strip
		isbn  = row['i.s.b.n.'].to_i

		# pp title
		results = db.execute(Query, [title,isbn,row['i.s.b.n.'], isbn])
		
		if !results  || results == []
			missing << title
			# pp isbn
			# pp row['i.s.b.n.']
		end
	end
	return missing
end

# Get row data
def get_results(db,file)
	CSV.foreach(file, headers:true ) do |row|
		next unless row
		title = row['title'].to_s.strip
		isbn  = row['i.s.b.n.'].to_i

		results = db.execute(Query, [title,isbn,row['i.s.b.n.'], isbn])
		next if !results  || results == [] 
		results = results[0]
		
		yield row, results
	end
end

UpdateDates = <<-SQL
	Update ZBOOKEDITION
	Set ZCUSTOMDATE = ?
	WHERE ZISBN == ? 
SQL
def update_dates(db,file)
	get_results(db,file) do |csv_row, db_results|
		str_date = Time.parse(row['purchase date']) - Time.parse('2001-01-01')
		results = db.execute(UpdateDates, [str_date.to_i,results['ZISBN']])
		puts results
	end
end

UpdateGenres = <<-SQL
	Update ZBOOK
	Set ZGENRE  = ?
	WHERE ZTITLE == ? 
SQL

def update_genres(db,file)
	get_results(db,file) do |csv_row, db_results|
		results = db.execute(UpdateGenres, [csv_row['genres'],db_results['ZTITLE']])
		puts results
	end
end

UpdateFormats = <<-SQL
	Update ZBOOKEDITION
	Set ZFORMAT  = ?
	WHERE ZISBN == ? 
SQL

def update_formats(db,file)
	get_results(db,file) do |csv_row, db_results|
		results = db.execute(UpdateFormats, [csv_row['format'],db_results['ZISBN']])
		puts results
	end
end

UpdatePrice = <<-SQL
	Update ZBOOKEDITION
	Set ZPRICE  = ?
	WHERE ZISBN == ? 
SQL

def update_price(db,file)
	get_results(db,file) do |csv_row, db_results|
		next unless csv_row['retail price']
		price = csv_row['retail price'].gsub(/\W+/, '').to_f/100
		results = db.execute(UpdatePrice, [price,db_results['ZISBN']])
		puts results
	end
end

UpdateRead = <<-SQL
	Update ZBOOK
	Set ZWasRead  = 1,
	    ZDateRead = '-63114076800'
	WHERE ZTITLE == ? 
SQL

def update_read(db,file)
	get_results(db,file) do |csv_row, db_results|
		next unless csv_row['played / read']
		read = csv_row['played / read'].to_i
		if read == 1 then
			results = db.execute(UpdateRead, db_results['ZTITLE'])
			puts results
		end
	end
end

UpdateOwn = <<-SQL
	Update ZBOOKEDITION
	Set ZOWN  = 1
	WHERE ZISBN == ? 
SQL

def update_own(db,file)
	get_results(db,file) do |csv_row, db_results|
		next unless db_results
		results = db.execute(UpdateOwn, db_results['ZISBN'])
		puts results
	end
end


# find_missing db, csv_file

# update_dates    db, csv_file
# update_genres   db, csv_file
# update_formats  db, csv_file
# update_price    db, csv_file
update_read    db, csv_file
update_own     db, csv_file