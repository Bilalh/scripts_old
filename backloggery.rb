#!/usr/bin/env ruby19 -KU
require 'rubygems'
require 'mechanize'
require "pp"

class Backloggery
	
	Progress={
		unfinished: 0,
		beaten:     1,
		completed:  2,
		null:       3,
		mastered:   4
	}

	Regions={
		NTSC:  0,
		NTSCJ: 1,
		PAL:   2
	}

	Ownership={
		owned:          0,
		formerly_owned: 1,
		borrowed:       2,
		rented:         2,
		other:          3
	}

	TextFields = [
		:console,
		:note,
		:comments
	]
	
	RadioButtons =[
		:own,
		:complete
	]
	
	SelectionList =[
		:region
	]
	
	Mapping ={
		own:      Ownership,
		complete: Progress,
		region:   Regions
	}
	
	
	# Fields 
	# name
	# console
	# complete   (radiobutton)
	# note

	
	def initialize
		@agent = Mechanize.new
		@agent.user_agent = 'Mozilla firefox'
		@agent.cookie_jar.load File.expand_path('~/cookies.txt'), :cookiestxt
	end
	
	def add_game(name,args={})
		page = @agent.get 'http://www.backloggery.com/newgame.php?user=bhterra'
		form = page.form
		
		# name can't be done easily
		form.field_with(:name => 'name').value =  name
		
		(args.keys & TextFields).each do |name|
		 	form[name.to_s] = args[name]
		end
		
		# For radiobuttons
		buttons =  lambda do |allowed,method, &block|
			(args.keys & allowed).each do |name|
				val   =  args[name]
				
				# Get the index from the value 
				index = 
				if val.class == Fixnum then
					val
				else
					Mapping[name][val]
				end

				button = form.send(method,:name => name.to_s)
				block.call button, index
			end
		end
		
		buttons.call(RadioButtons,:radiobuttons_with) do |button,index|
			button[index].check
		end
		
		buttons.call(SelectionList,:field_with) do |button,index|
			button.options[index].select
		end
				
		# form.fields.each { |e| pp e.name if e.name != 'console' &&  e.name != 'orig_console'  }
		submitForm form
	end

	private
	def submitForm(form)
		button = form.buttons[-1] # stealth add
		results = @agent.submit(form, button)
	end
	
end


b = Backloggery.new
b.add_game  "test4s",  console:"SNES", complete: :completed,   own:3, region: :NTSCJ
