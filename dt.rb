#!/usr/bin/env ruby
start_date   = [2010, 10, 02] # date of cover
chapter      = 27
pages        = 41
page_rjust   = [3, '0']
cover        = "cover"

chibi        = 1
extra        = 11
extra_offset = 23
extra_rjust  = [2, '0']
extra_title  = "Vaeliapath"

Base    = "http://www.drowtales.com/mainarchive//"
Day     = (60*61*24)
start   = Time.local(*start_date)  
chapter = chapter.to_s.rjust 2, '0'

exit if pages < 1
puts start.strftime "#{Base}" "%Y%m%d" "c#{chapter}" "#{cover}" ".jpg" 

(1..pages).each do |i|
	time = start + Day * i
	num  = i.to_s.rjust *page_rjust
	puts time.strftime "#{Base}" "%Y%m%d" "c#{chapter}" "p#{num}" ".jpg" 
end

(1..chibi).each do |i|
	time = start + Day * (i+pages)
	num  = i > 1 ? "#{i}" : ""
	puts time.strftime "#{Base}" "%Y%m%d" "c#{chapter}" "chibi" "#{num}" ".jpg" 
end

(1..extra).each do |i|
	time = start + Day * (i+pages + chibi)
	num  = (i+extra_offset).to_s.rjust *extra_rjust
	puts time.strftime "#{Base}" "%Y%m%d" "c#{chapter}" "#{extra_title}" "#{num}" ".jpg" 
end
