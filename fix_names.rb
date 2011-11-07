#!/usr/bin/env ruby19 -wKU
# Bilal Hussain
# encoding: UTF-8
require 'optparse'

Help = %{Usage: #{File.basename $0} [-t] [glob]
Fix files names}
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
	when 1; glob = ARGV[0] 
end

lamb = if options[:test] then
		->(src, dst){ "Testing: #{src}\t#{dst}\n" } 
	else
		->(src, dst) do
			return if src == dst
			return "Error: #{src} would overwrite #{dst}\n" if File.exist? dst
			File.rename src, dst 
		end 
	end


Dir.glob(glob) do |name|
	next if options[:excludes].include? name
	ext = File.extname name # save the extension
	dst = name.chomp(ext)
	
	# fix the name
	dst.gsub! /[._]/, " "
	dst.gsub! /([_ ]{0,1}\[[^\[\]]*\][_ ]{0,1})|([_ ]{0,1}\([^\[\)]*\)[_ ]{0,1})/, ""
	dst.strip!
	dst << "#{ext}" # puts back the extension
	
	begin
		res = lamb[name, dst]
		res = "#{name}\t#{dst}\n" if res == 0
		print res
	rescue Exception => e
		puts e
	end
end
