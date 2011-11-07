#!/usr/bin/env ruby19 -wKU
# Bilal Hussain
require 'optparse'

Help = %{Usage: #{$0} [-t] $regex_match $regex_sub [glob]
Example: rename -t ".*([0-9]+).mp3" "Track \\1.mp3"}
options = {}; glob = '*'

OptionParser.new do |opts|
	opts.banner = Help
	opts.on("-t", "--[no-]test", "Only display the resulting filenames") { |v| options[:test] = v }
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
	dst = name.sub regex, ARGV[1]
	begin
		res = lamb[name, dst]
		res = "#{name}:\t#{dst}" if res == 0
		puts res
	rescue Exception => e
		puts e
	end
end
