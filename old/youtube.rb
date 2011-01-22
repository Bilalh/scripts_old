#!/usr/bin/env ruby
# encoding: utf-8
# Bilal Hussain

# v acutal watch3
#http://v2.cache1.c.youtube.com/videoplayback?ip=0.0.0.0&sparams=id%2Cexpire%2Cip%2Cipbits%2Citag%2Cratebypass%2Coc%3AU0dXRldRV19FSkNNN19PS0FD&itag=22&ipbits=0&sver=3&ratebypass=yes&expire=1281769200&key=yt1&signature=38E00A19528D6E927023DA3155E789E966B13887.BFF8BA6B9A4931533EFC0B187938A64A42C9E87A&id=1a45916110948fad&redirect_counter=1&title=Utawarerumono-Creditless-Opening-%5BHD%5D%5Bwww.savevid.com%5D

# 35|34  flv have differnt method

html = File.read(ARGV[0])

printf " %8s: %s\n", "near" , near      = html[/fmt_url_map.*?%26id%3D.*?%/]
puts                                    
printf " %8s: %s\n","fmt"   , fmt       = near[/fmt_url_map=(37|22|18)/,1]
printf " %8s: %s\n","v"     , v         = near[/%2Fv(\d+)(.)/,1]
printf " %8s: %s\n","cache" , cache     = near[/(ls)?cache\d+/]
printf " %8s: %s\n","bypass", bypass    = near[/Cratebypass(.*?)Coc%253(.*?)%26/,2]
printf " %8s: %s\n","expire", expire    = near[/expire%3D(.*?)%26/,1]
printf " %8s: %s\n","sig"   , signature = near[/signature%3D(.*?)%26/,1];
printf " %8s: %s\n","id"    , id        = near[/id%3D(.*?)%/,1]
printf " %8s: %s\n","title" , title     = "TITLE.mp4" 
puts


printf " %8s: %s\n", "full", full = "http://v#{v}.#{cache}.c.youtube.com/videoplayback?ip=0.0.0.0&sparams=id%2Cexpire%2Cip%2Cipbits%2Citag%2Cratebypass%2Coc%3#{bypass}&itag=#{fmt}&ipbits=0&sver=3&ratebypass=yes&expire=#{expire}&key=yt1&signature=#{signature}&id=#{id}&title=#{title}"

