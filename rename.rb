#!/usr/bin/env ruby -wKU
# Bilal Hussain
# encoding: UTF-8
require 'optparse'

Help = %{Usage: #{File.basename $0} [-t] $regex_match $regex_sub [glob]
Example: #{File.basename $0} -t ".*([0-9]+).mp3" "Track \\1.mp3"}
options = {excludes:[]}; glob = '*'

OptionParser.new do |opts|
	opts.banner = Help
	opts.on("-t",  "--[no-]test", "Only display the resulting filenames") do |v|
		options[:test] = v
	end
	opts.on( '-e', "--excludes" '--list a,b,c', Array, "Names to Excludes" ) do |l|
	  options[:excludes] = l
	end
end.parse!

case ARGV.length
	when 2; 
	when 3; glob = ARGV[2]
	else    puts "Needs at lest TWO arguments", Help; exit
end

begin
	regex = Regexp.new(ARGV[0])	
rescue RegexpError => e
	puts "RegexpError: #{e}"; exit
end

lamb = if options[:test] then
		->(src, dst){ "Testing: #{src}:\t#{dst}" } 
	else
		->(src, dst){ File.rename src, dst } 
	end

Dir.glob(glob) do |name|
	next if options[:excludes].include? name
	dst = name.sub regex, ARGV[1]
	begin
		res = lamb[name, dst]
		res = "#{name}:\t#{dst}" if res == 0
		puts res
	rescue Exception => e
		puts e
	end
end
