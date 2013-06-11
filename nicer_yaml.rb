#!/usr/bin/env ruby -wKU
require 'yaml'
require 'pp'
(print "#{File.basename $0} py_yaml.yaml"; exit) unless ARGV.length == 1
name = ARGV[0]
hash = YAML.load_file(name)

res = hash
# res = hash.delete_if do |k,v|
# 	v[":track"] == 1 && v[":disc"] == 1
# end

ext = File.extname name
name = name.chomp ext

File.open(name+".nicer" + ext,'w') do |f|
	 f.write(res.to_yaml)
end
