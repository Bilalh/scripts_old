#!/usr/bin/env ruby -wKU
(puts "#{File.basename $0} hexcolour"; exit) unless ARGV.length == 1 

hex = ARGV[0].gsub(/^#/, "").to_i(16)
rgb = {}
%w(b g r).inject(hex) {|a,i| rest, rgb[i] = a.divmod 256; rest}
# p rgb
puts "%0.3ff,%0.3ff,%0.3ff" % [rgb["r"]/255.0, rgb["g"]/255.0,rgb["b"]/255.0]