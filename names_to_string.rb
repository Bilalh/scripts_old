#!/usr/bin/env ruby -KU
arr=[
	"Ludwig van Beethoven        ",
	"Franz Joseph Haydn          ",
	"Richard Strauss             ",
	"Mikhail Glinka              ",
	"Pyotr Il'yich Tchaikovsky   ",
	"Pyotr Il'yich Tchaikovsky   ",
	"Alexander Borodin           ",
	"Johannes Brahms             ",
	"Johannes Brahms             ",
	"Antonin Dvorák              ",
	"Antonin Dvorák              ",
	"Maurice Ravel               ",
	"Frédéric Chopin             ",
	"Franz Liszt                 ",
	"Sergey Rachmaninov          ",
	"Sergey Rachmaninov          ",
	"Michiru Oshima              ",
	"Franz Schubert              ",
	"Wolfgang Amadeus Mozart     ",
	"Wolfgang Amadeus Mozart     ",
	"Wolfgang Amadeus Mozart     ",
	"Maurice Ravel               ",
	"Wolfgang Amadeus Mozart     ",
	"George Gershwin             ",
]

arr.map! { |e| e.strip }
puts arr.join ', '