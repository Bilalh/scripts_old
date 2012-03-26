#!/usr/bin/env ruby19 -KU
require_relative 'backloggery'

SNES= {
	NTSCJ: {
		beaten:[
			"Bahamut Lagoon"                            ,
			"Seiken Densetsu 3"                         ,
			"Tactics Ogre"                              ,
			"Tales of Phantasia"                        ,
			"Ys III: Wanderers from Ys"                 ,
			"Ys IV: Mask of the Sun"                    ,
			"Magic Knight Rayearth",
			"Star Ocean",
			"Fire Emblem: Seisen no Keifu",
			"Fire Emblem: Thracia 776",
			
			"Super Bomberman 4",
			"Super Bomberman 5",
			"Dragon Ball Z: Hyper Dimension",
			"Mega Man & Bass",
			"Mega Man 7"
		],
		
		completed:[
			"Dragon Quest I & II"                    ,
			"Dragon Quest V"                         ,
		 "Dragon Quest VI"
		],
		
		unplayed:[
			"Treasure Hunter G",
			"EarthBound",
			"Dual Orb II",
			"Romancing SaGa 3",
			"Fire Emblem: Monsho no Nazo",
			"Front Mission",
			"Cyber Knight",
			"Cyber Knight II",
			
		]
	},
	
	NTSC:{
		beaten:[
			"Breath of Fire"                            ,
			"Breath of Fire II"                         ,
			"E.V.O.: Search for Eden"                   ,
			"Final Fantasy IV"                          ,
			"Final Fantasy V"                           ,
			"Final Fantasy: Mystic Quest"               ,
			"Lufia & the Fortress of Doom"              ,
			"Lufia II: Rise of the Sinistrals"          ,
			"Ogre Battle: The March of the Black Queen" ,
			"Soul Blazer"                               ,
			"Super Mario RPG: Legend of the Seven Stars",
			"Terranigma"                                ,
			"The 7th Saga"                              ,
			"Robotrek",
			
			"Super Bomberman 1",
			"Super Bomberman 2",
			
			"Mega Man X",
			"Mega Man X2",
			"Mega Man X3",
			"SimCity",
			"Contra III: The Alien Wars",
			"Super Adventure Island",
			"Super Adventure Island II"
			
		],
		
		completed:[
			"Chrono Trigger"                         ,
		],
		
	},
	
	PAL:{
		completed:[
			"Super Mario World",
			"Super Mario All-Stars",
		"The Legend of Zelda: A Link to the Past",
		],
		
		beaten:[
			"Super Bomberman 3",
			"Ms. Pac-Man",
			"Donkey Kong Country",
			"Donkey Kong Country 2: Diddy's Kong Quest",
			"Donkey Kong Country 3: Dixie Kong's Double Trouble!",
			"Super Mario World 2: Yoshi's Island",
			"The Lion King"
		]
		
	}
	
}

PSX = {
	NTSCJ:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	NTSC:{
		completed:[
			"Tales of Eternia",
		],
		
		beaten:[
		"Breath of Fire III",
			"Breath of Fire IV",
			"Final Fantasy: Origins",
			"Final Fantasy: Anthology",
			"Final Fantasy VII",
			"Final Fantasy VIII",
			"Final Fantasy IX",
			"Final Fantasy Tactics",
			"Hoshigami: Ruining Blue Earth",
			"Lunar: Silver Star Story Complete",
			"Lunar 2: Eternal Blue Complete",
			"Ogre Battle",
			
			"Mega Man Legends",
			"Mega Man Legends 2",
			"Rahpshody: A musical Adventure",
			"Star Ocean: The Second Story",
			"Suikoden",
			"Tactics Ogre",
			"Tales of Destiny II",
			"Torneko: The Last Hope",
			"Valkyrie Profile",
			
			"Crash Bandicoot 2: Cortex Strikes Back",
			"Crash Bandicoot 3: Warped",
			"Crash Bandicoot",
			"Spyro the Dragon",
			"Crash Team Racing",
			"Rayman",
			"Yu-Gi-Oh! Forbidden Memories",
			"Bomberman Land",
			"Tekken"
			
		],
		
		unfinished:[
			"Dragon Warrior VII",
			"Tales of Destiny",
			"Xenogears"
		],
		
		unplayed:[
			"Eternal Eyes",
			"Front Mission 3",
			"Grandia",
			"Legend of Legaia",
			"Legend of Mana",
			"Arc the Lad Collection Box ArtArc the Lad Collection",
			"Brave Fencer Musashi",
			"Chrono Cross",
			"Parasite Eve",
			"Persona",
			"Persona 2: Eternal Punishment",
			"Suikoden II",
			"The Legend of Dragoon",
			"Vagrant Story",
			"Vandal Hearts",
			"Vandal Hearts II",
			"Wild Arms",
			"Wild Arms II",
			"SaGa Frontier",
			"Tales of Phantasia",
			
		]
		
	},
	
	PAL:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	}
}

GBC = {
	NTSCJ:{
		completed:[
		
		],
		
		beaten:[
		],
		
		unfinished:[
		
		]
	},
	
	NTSC:{
		completed:[
		
		],
		
		beaten:[
			"Dragon Warrior Monsters 2: Tara's Adventure",
			"Dragon Warrior Monsters 2: Cobi's Journey",
			"Dragon Warrior III",
			"Dragon Warrior I&II",
			"Final Fantasy Legend III",
			"Medarot: Kabuto",
			"Final Fantasy Adventure",
			"Bomberman Quest",
			""
		],
		
		unfinished:[
		
		],
		
		unplayed:[
			"Lufia: The Legend Returns"
		]
	},
	
	PAL:{
		completed:[
			"Pokemon Blue",
			"Dragon Warrior Monsters",
			"Super Mario Land",
			"Super Mario Land 2: 6 Golden Coins",
			"The Legend of Zelda: Link's Awakening",
			"The Legend of Zelda: Link's Awakening DX",
			"The Legend of Zelda: Oracle of Ages",
			"The Legend of Zelda: Oracle of Seasons",
			"Wario Land II",
		],
		
		beaten:[
			"Pokemon Yellow",
			"Pokemon Red",
			"Pokemon Silver",
			"Pokemon Crystal",
			"Tetris",
			"Dr. Mario",
			"Pokemon Pinball",
			"Super Mario Land 3: Wario Land",
			"Kirby's Dream Land",
			"Super Mario Bros. Deluxe",
			"Donkey Kong Land",
			"Pokemon Trading Card Game",
			"Wario Land 3",
			"Donkey Kong Country",
			"Alleyway",
			"Quest for Camelot"
		],
		
		unfinished:[
		
		]
	}
}

NES = {
	NTSCJ:{
		completed:[
		
		],
		
		beaten:[
			"Dragon Quest IV",
			"Dragon Quest III",
			"Dragon Quest II",
			"Dragon Quest"
		],
		
		unfinished:[
		
		]
	},
	
	NTSC:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	PAL:{
		completed:[
		
		],
		
		beaten:[
			"Super Mario Bros",
			"The Legend of Zelda",
			"Zelda II: The Adventure of Link",
			"Super Mario Bros. 2",
			"Mario Bros",
			"Mega Man 2",
			"Mega Man",
		],
		
		unfinished:[
		
		]
	}
}

GEN = {
	NTSCJ:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	NTSC:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	PAL:{
		completed:[
		
		],
		
		beaten:[
			"Sonic the Hedgehog 2",
			"Sonic the Hedgehog",
			"Sonic the Hedgehog 3",
			"Genesis 6-Pak",
		],
		
		unfinished:[
		
		]
	}
}

GBA = {
	NTSCJ:{
		completed:[
		
		],
		
		beaten:[
			"Golden Sun: The Lost Age",
			"Fire Emblem: Fuuin no Tsurugi",
			"RockMan EXE 4.5 Real Operation",
		],
		
		unfinished:[
		
		]
	},
	
	NTSC:{
		completed:[
			"Tactics Ogre: The Knight of Lodis",
			"Mega Man Battle Network",
		],
		
		beaten:[
			"Mega Man Battle Network 6",
			"Mega Man Battle Network 4: Blue Moon",
			"Final Fantasy I & II: Dawn of Souls",
			"Sword of Mana",
			"Final Fantasy IV Advance",
			"Tales of Phantasia",
			"Final Fantasy VI Advance",
			"Final Fantasy V Advance",
			"Mega Man Battle Network 5: Team Protoman",
			"Breath of Fire",
			"Breath of Fire II",
			"Lunar Legend",
			"Riviera: The Promised Land",
			"Lufia: The Ruins of Lore",
			"Dokapon: Monster Hunter",
			'Mario & Luigi: Superstar Saga',
			"Final Fantasy Tactics Advance",
			"Yu-Gi-Oh! The Sacred Cards",
			"Donkey Kong Country",
			"Sonic Advance 2",
			"Donkey Kong Country 2",
			"Mario Party Advance",
		],
		
		unfinished:[
		]
	},
	
	PAL:{
		completed:[
			"Golden Sun",
			"Golden Sun: The Lost Age",
			"Mario Kart: Super Circuit",
			"Super Mario World: Super Mario Advance 2",
			"Super Mario Advance 4: Super Mario Bros. 3",
			"Yoshi's Island: Super Mario Advance 3",
			"The Legend of Zelda: A Link to the Past",
			"Wario Land 4",
			"Advance Wars",
			"Advance Wars 2: Black Hole Rising",
		],
		
		beaten:[
			"Pokemon Ruby",
			"Mario & Luigi: Superstar Saga",
			"Kingdom Hearts: Chain of Memories",
			"Dragon Ball Z: The Legacy of Goku",
		],
		
		unfinished:[
		
		]
	}
}

Wii = {
	NTSCJ:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	NTSC:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	PAL:{
		completed:[
			"Super Paper Mario",
			"Dragon Quest Swords: The Masked Queen and the Tower of Mirrors",
			"Tales of Symphonia: Dawn of the New World"
		],
		
		beaten:[
			"The Legend of Zelda: Twilight Princess",
		],
		
		unfinished:[
			"The Legend of Zelda: Skyward Sword",
			"Xenoblade Chronicles"
		],
		wishlist:[
			"Tales of Graces",
			"The Last Story",
		]
	}
}

N64 = {
	NTSCJ:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	NTSC:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	PAL:{
		completed:[
			"Super Mario 64",
			"The Legend of Zelda: Ocarina of Time",
		],
		
		beaten:[
			"Mario Kart 64",
			"Super Smash Bros",
			"Pokemon Stadium",
			"Donkey Kong 64",
			"The Legend of Zelda: Majora's Mask",
			"Yoshi's Story",
			"Mario Party",
			"Bomberman 64",
			"Tetrisphere",
			"Bomberman Hero"
		],
		
		unfinished:[
		
		],
		
		wishlist:[
			"Jet Force Gemini",
			"Paper Mario"
		]
	}
}

GCN = {
	NTSCJ:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	NTSC:{
		completed:[
			"The Legend of Zelda: The Wind Waker",
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	PAL:{
		completed:[
			"Tales of Symphonia",
		],
		
		beaten:[
			"The Legend of Zelda: The Wind Waker",
		],
		
		unfinished:[
		
		],
		wishlist:[
			"Paper Mario: The Thousand-Year Door",
			"The Legend of Zelda: Four Swords Adventures",
			"Fire Emblem: Path of Radiance"
		]
	}
}

PS2 = {
	NTSCJ:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	NTSC:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	PAL:{
		completed:[
			"Final Fantasy X",
			"Final Fantasy XII",
			"Dragon Quest VIII: Journey of the Cursed King",
			"Ar tonelico 2: Melody of Metafalica",
			""
		],
		
		beaten:[
			"Final Fantasy X-2",
			"Star Ocean: Till The End of Time",
			"Rogue Galaxy",
			"Xenosaga Episode II",
			"Valkyrie Profile 2: Silmeria",
			"Suikoden V",
			"Star Ocean: Till the End of Time",
			"Suikoden Tactics",
			"Disgaea: Hour of Darkness",
			"Disgaea 2: Cursed Memories",
			"Atelier Iris: Eternal Mana",
			"Atelier Iris 2: The Azoth Of Destiny",
		],
		
		unfinished:[
			".hack//Infection Part 1",
			"La Pucelle: Tactics",
			"Drakengard 2",
			"Shin Megami Tensei",
			"Persona 3 FES"
		],
		
		unplayed:[
			"Shin Megami Tensei: Persona 4",
			"Odin Sphere",
			"Atelier Iris 3: Grand Phantasm",
			"Grandia II",
			"Mana Khemia: Alchemists of Al-Revis",
			"Shadow Hearts: From the New World",
			"Growlanser: Heritage of War"
		],
		
		wishlist:[
			"Suikoden III",
			"Tales of Destiny 2",
			"Suikoden IV",
			"Radiata Stories",
			"Tales of the Abyss",
			"Xenosaga Episode III: Also sprach Zarathustra",
			"Shadow Hearts",
			"Shadow Hearts: Covenant",
			""
		]
	}
}

PS3 = {
	NTSCJ:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	NTSC:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	PAL:{
		completed:[
			"Valkyria Chronicles",
			"Ar tonelico Qoga: Knell of Ar Ciel",
			"Enchanted Arms",
			""
		],
		
		beaten:[
			"Disgaea 3: Absence of Justice",
			"Eternal Sonata",
			"Gran Turismo 5 Prologue"
		],
		
		unfinished:[
			"Final Fantasy XIII",
			"Agarest: Generations of War",
			"Resistance: Fall of Man",
			"MotorStorm",
		],
		
		unplayed:[
			"Fallout 3",
			"Resonance of Fate",
			"White Knight Chronicles",
		],
		
		wishlist:[
			"Final Fantasy XIII-2",
			"Tales of Xillia",
			"Tales of Graces f",
			"Atelier Totori: The Adventurer of Arland",
			"Atelier Rorona: Alchemist of Arland",
			"Atelier Meruru: The Apprentice of Arland"
		]
		
	}
}

DS = {
	NTSCJ:{
		completed:[
			# "Dragon Quest IV: Michibikareshi Monotachi",
			# "Tales of Innocence"
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		],
		
		wishlist:[
			# "Tales of Hearts",
			# "Luminous Arc 3",
			"Xenosaga I-II"
		]
	},
	
	NTSC:{
		completed:[
			"Dragon Quest IX: Sentinels of the Starry Skies",
			"Dragon Quest IV: Chapters of the Chosen",
			"Dragon Quest VI: Realms of Revelation",
			"Dragon Quest V: Hand of the Heavenly Bride",
			"The World Ends With You",
			"Valkyrie Profile: Covenant of the Plume",
			"Luminous Arc",
			"Luminous Arc 2",
			"Atelier Annie: Alchemists of Sera Island",
		],
		
		beaten:[
			"Pokemon Diamond",
			"Final Fantasy III",
			"Dragon Quest Monsters: Joker",
			"Chrono Trigger",
			"Final Fantasy IV",
			"Mega Man Star Force Dragon",
			"Final Fantasy Tactics A2: Grimoire of the Rift",
			"Mega Man Star Force 2: Zerker x Ninja",
			"Suikoden Tierkreis",
			"Summon Night: Twin Age",
			"Super Robot Taisen OG Saga: Endless Frontier",
			"Dokapon Journey",
			"Magical Starsign",
			"Mario Party DS",
			"Professor Layton and the Curious Village",
			"The Legend of Zelda: Phantom Hourglass",
			"Kirby Super Star Ultra",
			"Final Fantasy XII: Revenant Wings",
			
		],
		
		unfinished:[
			"Pokemon Black",
			"Dragon Quest Monsters: Joker 2",
			"Final Fantasy Crystal Chronicles: Ring of Fates",
			"Final Fantasy: The 4 Heroes of Light",
			"Children of Mana",
			"Mega Man Star Force 3: Black Ace",
			"Etrian Odyssey",
			"Soma Bringer",
			"The Legend of Zelda: Spirit Tracks",
			"Yoshi's Island DS"
		],
		
		unplayed:[
			"Kingdom Hearts 358/2 Days",
			"Shin Megami Tensei: Devil Survivor",
			"Nostalgia",
			"Infinite Space",
			"Black Sigil: Blade of the Exiled",
			"Yggdra Unison",
			"Professor Layton and the Last Specter",
			"Kirby Squeak Squad",
		]
	},
	
	PAL:{
		completed:[
			"Mario & Luigi: Partners in Time",
			"Mario Kart DS"
		],
		
		beaten:[
			"New Super Mario Bros.",
			"Super Mario 64 DS"
		],
		
		unfinished:[
			"Mario & Luigi: Bowser's Inside Story",
		
		]
	}
}

PSP = {
	NTSCJ:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	NTSC:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	PAL:{
		completed:[
			
		],
		
		beaten:[
			
		],
		
		unfinished:[
			"Tactics Ogre: Let Us Cling Together",
		],
		
		unplayed:[
			"Final Fantasy Tactics: The War of the Lions",
			"Valkyria Chronicles II",
			"Final Fantasy IV: The Complete Collection",
			"Jeanne d'Arc",
		],
		
		wishlist:[
			"Crisis Core: Final Fantasy VII",
			"Final Fantasy Type-0",
			"Star Ocean: First Departure",
			"Star Ocean: Second Evolution",
			"Tales of Eternia",
			"Tales of Phantasia: Narikiri Dungeon X",
			"Valkyria Chronicles III: Unrecorded Chronicles",
			"Lunar: Silver Star Harmony",
			"Ys Seven",
			"Wild ARMs XF",
			"Frontier Gate",
			"The Legend of Heroes: Trails in the Sky "
		]
	}
}

Steam = {
	
	NTSC:{
		completed:[
		
		],
		
		beaten:[
			"Sid Meier's Civilization IV",
			"Sid Meier's Civilization IV: Warlords",
			"Sid Meier's Civilization IV: Beyond the Sword"
		],
		
		unfinished:[
		
		],
		
		unplayed:[
			"Breath of Death VII",
			"Cave Story+",
			"Terraria",
			"Trine",
			"Portal 2",
			"Cthilhu Saves the World"
		]
		
	},
}

PC = {
	
	PAL:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		],
		
		unplayed:[
			
		]
		
	},
}

Template = {
	NTSCJ:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	NTSC:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	},
	
	PAL:{
		completed:[
		
		],
		
		beaten:[
			
		],
		
		unfinished:[
		
		]
	}
}

data={
	# SNES: SNES
	# PSX: PSX
	# GBC: GBC
	# NES: NES
	# GEN:   GEN
	# GBA:GBA
	# Wii: Wii,
	# N64: N64
	# GCN: GCN
	# PS2:PS2
	# PS3:PS3
	# DS: DS
	# PSP: PSP
	Steam: Steam
	# PC: PC
}

own= {
	SNES: :other,
	PSX:  :other,
	PSX:  :other,
	GBC:  :other,
	NES:  :other,
	GEN:  :formerly_owned,
	GBA:  :other,
	Wii:  :owned,
	N64:  :owned,
	GCN:  :owned,
	PS2:  :owned,
	PS3:  :owned,
	DS:   :other,
	PSP:  :owned,
	
	Steam: :owned,
	PC:    :owned,
}

b = Backloggery.new

def main_loop(data,own)
	data.each_pair do |console, regions|
		_own = own[console]
		regions.each_pair do |region, progress|
			progress.each_pair do |status, titles|
				titles.each do |title|
					yield console, region, status, title, _own
				end
			end
			sleep 0.01
		end
	end
end

total = 0
main_loop(data,own) do |console, region, _status, title,own|
	unplayed, wishlist = false, false
	status = _status
	
	if status == :wishlist then
		unplayed = true
		wishlist = true
		status   = :unfinished
	elsif status == :unplayed then
		unplayed = true
		status   = :unfinished
	end
	
	b.add_game   "bhterra", title,  
		 console: console,
		  region: region, 
		complete: status,   
		     own: own, 
		  rating: 4,
	stealth_add: true,
	   unplayed: unplayed,
	   wishlist: wishlist
	
	puts "Added %s %s %s %s %s" %[console, region, _status, own, title]
	total +=1
end
puts "Added #{total} games"


# b.delete_in_range "bhterra", 5521310, 5521350