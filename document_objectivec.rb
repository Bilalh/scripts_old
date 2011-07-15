#!/usr/bin/env ruby19
string = STDIN.read
# string = '-(id) initWithFilename:(NSString *)filename;'
# string ='-(id) initWithFilename:(NSString *)filename;'
# string ='- (void) setAlbumUrl:(NSString *)url;'
# string ='- (void) initButtonsState;'
# 
# string = <<EOF
# - (NSMutableDictionary*) makeButtonProperties:(NSString*)b1Title
#  								 button1Full:(NSString*)b1Full
#  								button2Title:(NSString*)b2Title
#  								 button2Full:(NSString*)b2Full
#  										name:(NSString*)name;
# EOF
# string = '- (NSString*) initWithTagString:(String::s) cppString;'

vars = string.scan(/\([\w *^:]+\)\s*(\w+)/m).flatten;
returnPrint  = !string[/(void|IBAction|IBOutlet)/]

puts <<-EOF
 /**  
  *
EOF

if vars.length >=2 then

max = vars[1].length
vars[1..-1].each { |e| max  = e.length if e.length > max }

vars[1..-1].each do |e|
	puts "  * @param #{e.ljust max} " 
end
puts "  *"
end

if returnPrint then
	puts "  * @return "
end

puts "  */"
puts string