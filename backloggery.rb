#!/usr/bin/env ruby19 -KU
# Bilal Hussain

# Allows adding games to Backloggery
# Requies:
# Ruby 1.9+
# Mechanize gem
# Requires a Backloggery account
# A cookie for logging in (firefox's format)

require 'mechanize'

class Backloggery
	
	attr_reader :agent
	
	Progress={
		unfinished: 0,
		beaten:     1,
		completed:  2,
		null:       3,
		mastered:   4
	}

	Regions={
		NTSC:   0,
		NTSCJ:  1,
		PAL:    2,
		china:  3,
		korea:  4,
		brazil: 5,
		
		na:     0,
		japan:  1,
		europe: 2
	}

	Ownership={
		owned:          0,
		formerly_owned: 1,
		borrowed:       2,
		rented:         2,
		other:          3
	}

	Ratings={
		none:  5,
		one:   4,
		two:   3,
		three: 2,
		four:  1,
		five:  0,
		0 =>   5,
		1 =>   4,
		2 =>   3,
		3 =>   2,
		4 =>   1,
		5 =>   0
	}

	TextFields = [
		:note,
		:comments,
		:online,
		:achieve1,
		:achieve2,
		:comp
	]

	ConsoleFields=[
		:console,
		:orig_console
	]
	
	RadioButtons =[
		:own,
		:complete,
		:rating
	]
	
	CheckButtons =[
		:unplayed,
		:playing,
	]
	
	SelectionList =[
		:region
	]
	
	Mapping ={
		own:      Ownership,
		complete: Progress,
		region:   Regions,
		rating:   Ratings
	}

	#  cookies is the path to the cookies file
	def initialize cookies=File.expand_path('~/cookies.txt')
		@agent = Mechanize.new
		@agent.user_agent = 'Mozilla firefox'
		@agent.cookie_jar.load cookies, :cookiestxt
	end
	
	def userpage user
		@agent.get "http://www.backloggery.com/games.php?user=#{user}"
	end
	
	
	def add_game(user,title,args={})
		# puts title
		# pp args
		page = @agent.get "http://www.backloggery.com/newgame.php?user=#{user}"
		form = page.form
		
		# name can't be done easily
		form.field_with(:name => 'name').value =  title
		
		(args.keys & TextFields).each do |name|
		 	form[name.to_s] = args[name]
		end
		
		(args.keys & ConsoleFields).each do |name|
			val  = args[name].to_s
			val  = Consoles[val] if Consoles.has_key? val
			form[name.to_s] = val
		end

		(args.keys & CheckButtons).each do |name|
			val  = args[name]
			val  = Consoles[val] if Consoles.has_key? val
			form.checkbox_with(:name =>  name.to_s).checked = true
		end

		buttons =  lambda do |allowed,method, &block|
			(args.keys & allowed).each do |name|
				val   =  args[name]
				
				# Get the index from the value 
				index = 
				if  name != :rating &&  val.class == Fixnum then
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
		
		# f = form.field_with(:name => "console")
		# f.node.children.each_with_index do |node, i|
		# 	short  = node.attributes["value"].value.inspect
		# 	name = node.children.text.inspect
		# 	
		# 	puts "%30s  => #{short}," % name
		# 	
		# end

		stealth_add = args.has_key?("stealth_add") ? args[stealth_add] : false
			
		submitForm form, stealth_add
	end

	def delete_in_range(user,lower,upper,stealth_delete=true)
		(arr=(lower..upper).to_a).map! do |e|
			"http://www.backloggery.com/update.php?user=#{user}&gameid=#{e}"
		end
		delete arr,stealth_delete
	end

	def delete(links,stealth_delete=false)
		text = stealth_delete ? "delete2" : "delete1"
		links.each do |link|
			page = @agent.get link
			form = page.form
			next unless form
			
			_button =nil
			form.buttons.each do |button|
				if button.name==text then
					_button = button
					break
				end
			end

			@agent.submit(form, _button)
			puts "Deleted #{link}"
		end
	end

	private
	def submitForm(form,stealth_add=false)
		button = form.buttons[stealth_add ? 0 : -1] # stealth add
		results = @agent.submit(form, button)
	end

	
	Consoles={
		"Game Wave Family Entertainment System"  => "GWFES",
		"Super Nintendo Entertainment System"    => "SNES",
		              "Super Nintendo"  => "SNES",
		                         "32X"  => "32X",
		                         "3DO"  => "3DO",
		            "Acorn Archimedes"  => "AcornA",
		                       "Amiga"  => "AMG",
		                  "Amiga CD32"  => "CD32",
		                 "Amstrad CPC"  => "AMS",
		              "Amstrad GX4000"  => "GX4k",
		                     "Android"  => "Droid",
		                   "APF-M1000"  => "APF",
		                    "Apple II"  => "AppII",
		         "Apple Bandai Pippin"  => "Pippin",
		                      "Arcade"  => "ARC",
		                  "Atari 2600"  => "2600",
		                  "Atari 5200"  => "5200",
		                  "Atari 7800"  => "7800",
		                 "Atari 8-bit"  => "Atr8b",
		                    "Atari ST"  => "AtrST",
		             "Bally Astrocade"  => "Astro",
		                  "Battle.Net"  => "BNet",
		                   "BBC Micro"  => "BBC",
		                     "Browser"  => "Brwsr",
		                  "Calculator"  => "CALC",
		                        "CD-i"  => "CDi",
		                       "CD32X"  => "CD32X",
		                 "Coleco Adam"  => "Adam",
		                "ColecoVision"  => "CV",
		                "Commodore 64"  => "C64",
		              "Commodore CDTV"  => "CDTV",
		            "Commodore Plus/4"  => "Plus4",
		            "Commodore VIC-20"  => "VIC20",
		                  "Cougar Boy"  => "CBoy",
		                      "Desura"  => "Desura",
		                         "DOS"  => "DOS",
		                      "DotEmu"  => "DotEmu",
		                "Dragon 32/64"  => "Dragon",
		                   "Dreamcast"  => "DC",
		                     "DSiWare"  => "DSiW",
		        "Emerson Arcadia 2001"  => "Arc2k1",
		         "Fairchild Channel F"  => "ChF",
		         "Famicom Disk System"  => "FDS",
		                    "FM Towns"  => "FMT",
		             "Fujitsu Micro 7"  => "FM7",
		                      "Gamate"  => "Gamate",
		                "Game & Watch"  => "GW",
		                   "Game Gear"  => "GG",
		              "Game Boy/Color"  => "GBC",
		            "Game Boy Advance"  => "GBA",
		                    "e-Reader"  => "eRdr",
		                    "GameCube"  => "GCN",
		                          "GC"  => "GCN",
		                     "GameFly"  => "GFly",
		                  "GamersGate"  => "GGate",
		           "Games For Windows"  => "G4W",
		                    "Game.com"  => "GCOM",
		        "Genesis / Mega Drive"  => "GEN",
		                    "GetGames"  => "GGames",
		                    "Gizmondo"  => "Gizm",
		              "Good Old Games"  => "GOG",
		                    "GP2X Wiz"  => "Wiz",
		                   "HyperScan"  => "HprScn",
		                     "Impulse"  => "Imp",
		               "Intellivision"  => "IntVis",
		                         "iOS"  => "iOS",
		                         "ios"  => "iOS",
		                        "iPad"  => "iPad",
		                        "iPod"  => "iPod",
		                      "iPhone"  => "iPhone",
		                      "Jaguar"  => "JAG",
		                   "Jaguar CD"  => "JagCD",
		                 "LaserActive"  => "LasAct",
		                       "Linux"  => "Linux",
		                        "Lynx"  => "Lynx",
		                         "Mac"  => "Mac",
		                         "OSX"  => "Mac",
		            "Magnavox Odyssey"  => "MagOdy",
		               "Master System"  => "SMS",
		                 "Microvision"  => "Micvis",
		               "Miscellaneous"  => "Misc",
		                      "Mobile"  => "Mobile",
		                         "MSX"  => "MSX",
		                      "N-Gage"  => "NGage",
		                 "NEC PC-8801"  => "PC88",
		                 "NEC PC-9801"  => "PC98",
		                     "Neo Geo"  => "NG",
		                  "Neo Geo CD"  => "NGCD",
		        "Neo Geo Pocket/Color"  => "NGPC",
		                "Nintendo 3DS"  => "3DS",
		               "3DS Downloads"  => "3DSDL",
		                 "Nintendo DS"  => "NDS",
		                 "Nintendo 64"  => "N64",
		               "Nintendo 64DD"  => "64DD",
		"Nintendo Entertainment System" => "NES",
		                        "Nuon"  => "Nuon",
		                      "Nuuvem"  => "Nuuvem",
		         "Odyssey² / Videopac"  => "Ody2",
		                      "OnLive"  => "OnLive",
		                      "Origin"  => "Origin",
		                     "Pandora"  => "Pndra",
		                          "PC"  => "PC",
		                "PC Downloads"  => "PCDL",
		                      "PC-50X"  => "PC50X",
		                       "PC-FX"  => "PCFX",
		                     "Pinball"  => "PB",
		                 "PlayStation"  => "PS",
		               "PlayStation 2"  => "PS2",
		               "PlayStation 3"  => "PS3",
		         "PlayStation Network"  => "PSN",
		              "PSOne Classics"  => "PS1C",
		                "PS2 Classics"  => "PS2C",
		           "PlayStation minis"  => "PSmini",
		        "PlayStation Portable"  => "PSP",
		            "PlayStation Vita"  => "PSVita",
		               "Plug-and-Play"  => "PnP",
		               "PocketStation"  => "PktStn",
		                "Pokémon Mini"  => "PkMini",
		                      "R-Zone"  => "RZN",
		               "RCA Studio II"  => "RCAS2",
		                   "SAM Coupé"  => "SAM",
		                      "Saturn"  => "Saturn",
		                     "Sega CD"  => "SCD",
		                   "Sega Pico"  => "Pico",
		                "Sega SG-1000"  => "SG1000",
		                    "Sharp X1"  => "X1",
		                "Sharp X68000"  => "X68k",
		                       "Steam"  => "Steam",
		                  "SuperGrafx"  => "SGfx",
		                    "TI-99/4A"  => "TI99",
		             "Tiger Handhelds"  => "Tiger",
		                    "TurboDuo"  => "TDuo",
		               "TurboGrafx-16"  => "TG16",
		               "TurboGrafx-CD"  => "TGCD",
		       "TRS-80 Color Computer"  => "TRS80",
		                     "Vectrex"  => "VECT",
		                 "Virtual Boy"  => "VB",
		             "Virtual Console"  => "VC",
		               "VC (Handheld)"  => "VCH",
		          "Watara Supervision"  => "SVis",
		                         "Wii"  => "Wii",
		                     "WiiWare"  => "WW",
		                       "Wii U"  => "WiiU",
		             "Windows Phone 7"  => "WinP7",
		            "WonderSwan/Color"  => "WSC",
		                   "XaviXPORT"  => "XXPORT",
		                        "Xbox"  => "Xbox",
		                    "Xbox 360"  => "360",
		            "Xbox LIVE Arcade"  => "XBLA",
		             "XNA Indie Games"  => "XNA",
		    "Xbox 360 Games on Demand"  => "XbxGoD",
		                       "Zeebo"  => "Zeebo",
		                        "Zune"  => "Zune",
		                 "ZX Spectrum"  => "ZXS",
	}
	
end

#  Example 
if $0 == __FILE__
	
	b = Backloggery.new
	b.add_game   "bhterra", "Game Name",  
		 console: :PSP, 
		complete: :mastered,   
		     own: :rented, 
		  region: :NTSCJ,
		comments: "Some comments",
		    note: "Some Notes",
		  rating: 3,
		
		unplayed: true,
		 playing: false,
		 # comp: "Some Compilation",  # Uncommet if in a Compilation
	stealth_add: true,
	
		
  orig_console: :SNES,
		  online: "Some online info",
		achieve1: 1,   # Number of Achievements
		achieve2: 2,   # Total number of Achievements
end