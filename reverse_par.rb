(puts "#{File.basename $0} filename\nPrints the file with pars reversed"; exit) unless ARGV.length == 1
file = IO.read(ARGV[0])
lines = file.split(/\n\n/)

lines.reverse.each { |e| puts e;puts }