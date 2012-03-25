#!/usr/bin/env ruby19 -KU
# Bilal Hussain

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
	
	def initialize cookies=File.expand_path('~/cookies.txt')
		@agent = Mechanize.new
		@agent.user_agent = 'Mozilla firefox'
		@agent.cookie_jar.load cookies, :cookiestxt
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
		
		# Radio buttons
		buttons.call(RadioButtons,:radiobuttons_with) do |button,index|
			button[index].check
		end
		
		# Selection list
		buttons.call(SelectionList,:field_with) do |button,index|
			button.options[index].select
		end
		
		submitForm form
	end

	private
	def submitForm(form,stealth_add=false)
		button = form.buttons[stealth_add ? 0 : -1] # stealth add
		results = @agent.submit(form, button)
	end
	
end


b = Backloggery.new
b.add_game   "test7s",  
	 console: "SNES", 
	complete: :completed,   
	     own: :rented, 
	  region: :NTSCJ,
	comments: "Some comments",
	    note: "Notes"
