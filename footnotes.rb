#!/usr/bin/env ruby19
require 'nokogiri'
require 'open-uri'

	# Open the html 
	doc = Nokogiri::HTML(open(ARGV[0]))
	# Finds by the number by counting the list elements  
	number_of_footnotes =  doc.css('ol.references').xpath('li').length
	
	# places the footnote inline
	(0...number_of_footnotes).each do |i|  
		current_foonote = nil
		current_note    = "#_note-#{i}"
		current_ref     = "#_ref-#{i}"
		
		doc.css(current_note).each do |ele|
			ele2                = ele.dup(1) # deep copy
			ele2.name           = 'span'
			ele2['class']       = 'footnote'
			ele2.remove_attribute 'id'
			current_foonote = ele2
		end

		doc.css(current_ref).each do |ele|
			ele.add_next_sibling(current_foonote)
		end
	end

	# Removes elements that the css or the xpath
	css_arr = ['table.toc', 'div#jump-to-nav', 'h3#siteSub', 'head>link', 
							'.noprint', 'div#footer', 'div.suggestions'
						]
	
	xpath_arr = ['//script', '//table[@border="1"]//*[contains(., "Main Page")]']
				
	css_arr.each do |css|
		doc.css(css).each {|e| e.unlink}
	end
	
	xpath_arr.each do |css|
		doc.xpath(css).each {|e| e.unlink}
	end
	
	# Adds a link to our stylesheet 
	style = Nokogiri::XML::Node.new "link", doc
	style['rel']  = 'stylesheet'
	style['href'] = 'styles.css'

	head = doc.xpath('//head')
	head.children.last.add_next_sibling style
	
	# Fixes the title and the headings
	title      = doc.xpath('//title');
	text_node  = title.children.first
	
	text =  text_node.content
	text.gsub! /\s*-\s*Baka-Tsuki/, ""
	text.gsub! /[- :_]*Volume\s*(\d+)/, ' - Volume \1'
	text_node.content = text
	
	heading = doc.css('h1#firstHeading')
	heading.children.last.content = text
	
puts doc


