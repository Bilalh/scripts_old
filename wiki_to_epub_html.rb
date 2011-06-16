#!/usr/bin/env ruby19
require 'nokogiri'
require 'open-uri'
require 'fileutils'

# Usage either
# save_dir base_url url
# config_file
# 
# config_file is:
#	save_dir
#	base_url
#	{url}+"

# Requirements 
# Ruby 1.9 with nokogiri gem

# Transform the a wiki page into epub friendly html 
# and gets larger versions of the images
class WikiePub
	
	# Array of strings of the elements to remove 
	# by css e.g.   table.toc
	# by xpath e.g. //script
	attr_accessor :css_arr, :xpath_arr
	
	def initialize(base_dir)
		@dir = File.expand_path(base_dir) + '/'
		FileUtils.mkdir_p @dir
		puts "Saving files to: #{base_dir}\n"
		
		@css_arr = ['table.toc', 'div#jump-to-nav', 'h3#siteSub', 'head>link', 
								'.noprint', 'div#footer', 'div.suggestions', 'span.editsection',
								'div.thumbcaption', 'div.printfooter', 'div.portlet'
							 ]

		@xpath_arr = ['//script', '//table[@border="1"]//*[contains(., "Main Page")]'
									
								 ]
	end

	def tranform_to_epub_friendly(base,page,meta_elements={},resize_images=true)
		@base  = base
		@doc   = Nokogiri::HTML(open(base + page))
		puts "Downloading #{base + page}"
		tranform_html(@doc,meta_elements)
		get_images(@doc,resize_images)
	end

	# Getter larger images and place them in @dir/images/
	def get_images(doc, resize_images=true)
		puts "Getting images"
		FileUtils.mkdir_p @dir + '/images/'
		
		# find each img element
		doc.css('a > img').each do |img_ele|
			
			a_ele   = img_ele.parent
		  a_href  = @base + a_ele['href']
			puts "Image page url: " + a_href
			
			# Set the new filename
			filename       = 'images/' + a_href[/File:(.+\..+)/,1]
			img_ele['src'] = filename
			a_ele['href']  = filename
			puts "Filename: " + filename
			
			# Don't resize the gallary box at the top if it exists
			if resize_images and img_ele.parent.parent.parent['class'] != 'thumb' then
	 			width             = Integer(img_ele['width'])
				width             = width * 2
				img_ele['width']  = width.to_s
			
				height            = Integer(img_ele['height'])
				height            = height * 2
				img_ele['height'] = height.to_s
			end
			
			
			if File.exists?(@dir + filename) then
				puts "Image #{filename} exists, not downloading"
				next
			end
			
			# opens the url of the page containing the full size image 
			img_page = Nokogiri::HTML(open(a_href))
	
			#finds the url of the image
			img_page.css('div.fullImageLink > a > img').each do |img_ele|
				img_url = @base + img_ele['src']
				puts "Image url: " + img_url
				download(img_url, filename)
			end
			
		end
	end

	# Transforms the html to make it convert easily to epub
	def tranform_html(doc, meta_elements={})
		# Finds by the number by counting the list elements  
		
		
		# Places the footnote inline
		doc.css('ol.references').xpath('li').each do |li|
			
			current_foonote = nil
			current_note    =  li['id']
			a_ele           =  li.xpath('a')	
			current_ref     =  a_ele.first['href']
			#puts "current_note: #{current_note} current_ref: #{current_ref}"
			
			# Gets a deep copy of the footnote
			doc.css('#' + current_note).each do |ele|
				ele2                = ele.dup(1) # deep copy
				#ele2.name           = 'span'
				ele2['class']       = 'footnote'
				ele2.remove_attribute 'id'
				current_foonote = ele2
			end
			
			# Adds the node inline
			doc.css(current_ref).each do |ele|
				ele.parent.add_child(current_foonote)
			end
			
		end

		# Removes elements that the css or the xpath
		@css_arr.each do |css|
			doc.css(css).each {|e| e.unlink}
		end

		@xpath_arr.each do |css|
			doc.xpath(css).each {|e| e.unlink}
		end

		# Adds a link to our stylesheet 
		head = doc.xpath('//head')
		
		
		# Fixes the title and the headings
		title      = doc.xpath('//title');
		text_node  = title.children.first

		text =  text_node.content
		text.gsub! /\s*-\s*Baka-Tsuki/i, ""
		text.gsub! /\s?Full Text/i, ""
		text.gsub! /[- :_]*Volume\s*(\d+)/i, ' - Volume \1'
		text_node.content = text
		
		
		heading = doc.css('h1#firstHeading')
		heading.children.last.content = text
		@title =  text.gsub ' ', '_'
		
		unless meta_elements.has_key? 'series'
			add_child(head, 'meta',
				name: 'series', 
				content:  text.gsub(/\s+-?\s*Volume\s*\d+/i, "")  
			)
		end
		
		meta_elements.each_pair do |name, val| 
			add_child(head, 'meta',
				name: name.to_s,
				content: val
			)
		end
		
		# Adds a reference to the style sheet
		add_child(head, 'link', 
			rel: 'stylesheet', 
			href: 'styles.css' 
		)
		
	end


	# Write the transform xml to file
	def write_html_to_file(filename=@title)
		create_css()
		filename << '.html' unless filename[/\.(x)?html$/]
		filename.gsub!(/[\/:]/, '_')
		File.open(@dir + filename, 'w'){|f| f.write(@doc.to_html)}
		puts "Saved to #{@dir + filename}"
	end

	private

	def add_child(head_ele, name, opts={} )
		ele = Nokogiri::XML::Node.new name, @doc
		opts.each_pair do |name, val| 
			ele[name.to_s] = val
		end
		head_ele.children.last.add_next_sibling ele
	end

	# Downloads the specifed file to the specifed place
	def download(full_url, to_here)
	      writeOut = open(@dir + to_here, "wb")
	      writeOut.write(open(full_url).read)
	      writeOut.close
	end

	# Creates @dir/styles.css if does not exist
	def create_css()
		return if File.exists?(@dir + 'styles.css')
		content =<<-CSS
		.footnote {
			border: 1px gray dashed;
			display: block;
			float: right;
			font-size: 0.75em;
			line-height: 12pt;
			margin-bottom: 8pt;
			margin-left: 16pt;
			margin-right: 0;
			margin-top: 0.2em;
			max-width: 33%;
			padding-bottom: 8pt;
			padding-left: 24pt;
			padding-right: 8pt;
			padding-top: 8pt;
			text-align: left;
			text-indent: -16pt;
			width: 250px
		}
		.image-wrapper {
			border: 1px gray solid;
			display: block;
			float: right;
			margin-bottom: 8pt;
			margin-left: 16pt;
			margin-right: 0;
			margin-top: 0.2em;
			max-width: 33%;
			padding-bottom: 8pt;
			padding-left: 8pt;
			padding-right: 8pt;
			padding-top: 8pt;
			width: 250px
		}
		.terminal {
			display: block;
			font-family: monospace;
			margin-bottom: 16pt;
			margin-left: 16pt;
			margin-right: 0;
			margin-top: 16pt
		}
		pre {
			padding: 1em;
			border: 1px dashed #2f6fab;
			color: black;
			background-color: #f9f9f9;
			line-height: 1.1em;
		}
		CSS
		File.open(@dir + 'styles.css', 'w'){|f| f.write(content)}
	end
		
end

# reads and acts upon a config file
class WikiePubConfig
	
	def initialize(filename)
		
		resize_images = true

		lines = IO.readlines filename
		(puts "invalid file"; exit) unless lines.length >= 3

		save_dir, base_url = lines[0].strip, lines[1].strip
		w = WikiePub.new save_dir

		meta = {}
		opts = {}
		lines[2..-1].each do |line|
			line.strip!

			case line[0]
			when ':' 
				parse_meta_opts(meta,line)
				next
			when '+'
				parse_opts(w,opts,line[1..-1],true)
				next
			when '-'
				parse_opts(w,opts,line[1..-1], false)			
				next
			end
			
			#Remove the base path from the url if it is there
			url_part = line.sub base_url, ""

			w.tranform_to_epub_friendly(
				base_url, 
				url_part,
				meta,
				opts[:resize_images]
			)

			w.write_html_to_file
			puts
		end
	end
	
	private
	# parses the options
	
	def parse_meta_opts(meta_opts,line)
		if line.length == 1 then
			meta_opts.clear
			puts "metadata cleared"
			sleep 4 + (rand 3)
		else
			split = line.split ':'
			meta_opts[split[1]] = split[2]
			puts "#{split[1]}: #{split[2]}"
		end
	end
	
	def parse_opts(w,opts,line, bool)
		
		case line 
		when 'css'
			w.css_arr={} if !bool
		when 'xpath'
			w.xpath_arr={} if !bool
			
		when /css:.+/
			w_array_add line, bool, 'css_array', w.css_arr
		when /xpath:.+/
			w_array_add line, bool, 'xpath_array', w.xpath_arr
			
		else 
			puts "#{line} #{bool}"
			opts[line.to_sym] = bool
		end
		
	end
	
	def w_array_add(line, bool,name,arr)
		split = line.split ':'
		arg = split[1..-1].flatten.join ''
		if bool then
			puts "Added `#{arg}' to #{name}"
	 		arr << arg unless arr.include? arg
		else 
			puts "Removed `#{arg}' to #{name}"
			arr.delete arg
		end
	end
	
	public 
	def self.print_help
		puts "config_file is:
			save_dir
			base_url
			{url}+"
		puts "In the config_file metadata can be specified using a : e.g."
		puts ":author:Urobuchi Gen"
		puts ":series:Fate/Zero"
		puts "Also options can be used such as -resize_images and +resize_images"
		puts "+css:ele to add css elements -css:ele to remove, same for xpath as well"
		puts "-css to remove all elements, -xpath remove all elements"
		puts ""
		
	end
	
end


unless ARGV.length == 3 or ARGV.length == 1
	puts "#{File.basename $0} save_dir base_url url"
	puts "#{File.basename $0} config_file"
	WikiePubConfig.print_help
	exit
end

if ARGV.length == 3 then
	
	w = WikiePub.new(ARGV[0])

	#Remove the base path from the url if it is there
	url_part = ARGV[2].sub ARGV[1], ""

	w.tranform_to_epub_friendly(
		ARGV[1], 
		url_part
	)
	w.write_html_to_file
	
elsif ARGV.length == 1 then
		WikiePubConfig.new ARGV[0]	
end
