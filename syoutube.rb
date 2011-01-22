#!/usr/bin/env ruby
# encoding: utf-8
# Bilal Hussain

html = File.read(ARGV[0])
puts fmt = html[/fmt_url_map.*?(37|22|18)/,1] 
puts t   = html[/&t=[\w-]+/]
puts video_id = html[/canonical.*?v=([\w-]+)/,1]
puts "http://www.youtube.com/get_video?video_id=#{video_id}#{t}%3D&fmt=#{fmt}&asv=2"


