#!/usr/bin/env ruby -wKU
# encoding: UTF-8
# Bilal Syed Hussain


require "SecureRandom"

def to_hh_mm_ss_ms(duration_ms)
	duration = duration_ms / 1000
  [duration / 3600,  (duration / 60) % 60, duration % 60 ].map do |t|
  	t.to_s.rjust(2, '0')
  end.join(':') + ".#{duration_ms % 1000}"
end

def to_ms(hh_mm_ss_ms)
	a=[1, 1000, 60000, 3600000]*2
	hh_mm_ss_ms.split(/[:\.]/).map do |time|
		time.to_i*a.pop
	end.inject(&:+)
end


times = %{a-001.mkv	00:01:51.130
a-002.mkv	00:06:39.403
a-003.mkv	00:04:02.257
a-004.mkv	00:06:30.389
a-005.mkv	00:06:00.373
a-006.mkv	00:05:17.337
a-007.mkv	00:09:34.249
a-008.mkv	00:04:15.591
a-009.mkv	00:04:35.530
a-010.mkv	00:05:12.098
a-011.mkv	00:05:24.333
a-012.mkv	00:10:23.627
a-013.mkv	00:05:11.314
a-014.mkv	00:04:06.251
a-015.mkv	00:04:35.277
a-016.mkv	00:02:38.177
a-017.mkv	00:00:02.015
a-018.mkv	00:10:03.616
a-019.mkv	00:06:01.501
a-020.mkv	00:05:27.200
a-021.mkv	00:04:30.286
a-022.mkv	00:06:21.381
a-023.mkv	00:02:43.166
a-024.mkv	00:05:11.313
a-025.mkv	00:06:08.247
a-026.mkv	00:10:50.450
}

uid = %{a-001.mkv	 bf 2b c4 3f 3a 3e 6b 8c d5 a8 0b 95 25 9a 11 4d
a-002.mkv	 fb 83 16 c3 bf f0 6e 7c 60 30 cc 85 3c ae 88 74
a-003.mkv	 2b 80 8f 06 4e 14 e3 f0 a7 92 f2 08 3c b6 9b f7
a-004.mkv	 64 e1 91 5e a5 47 bc 3d 6c 33 d9 b6 ee e9 4b 86
a-005.mkv	 55 f9 09 19 8a e8 34 e5 cb 7d 32 78 38 5b 90 4a
a-006.mkv	 83 3f 1b 43 7a 32 c2 67 08 2e 8b 09 49 84 7a f0
a-007.mkv	 cc 9b c9 dc cb 85 7e 94 c4 9e 27 ad 7e 8b 29 3f
a-008.mkv	 8d 9d de b1 02 97 85 ac f1 f1 fd ee 3e 53 7b ca
a-009.mkv	 98 a1 f9 da 75 41 32 3b 88 8d 81 18 17 60 85 4b
a-010.mkv	 e9 71 ea c9 86 25 14 34 b8 ad 90 14 4c 54 71 c0
a-011.mkv	 0a 8d c4 62 3f bd 07 dd 36 88 77 0b 1e a1 be 22
a-012.mkv	 53 b4 bf 4d 3e 6a d4 8c 80 a3 75 5c a5 34 ae c9
a-013.mkv	 a2 f6 13 4e c8 72 e4 5c f0 2e 69 53 f5 a0 ba af
a-014.mkv	 9a 7a 97 d0 15 94 1c 7e 97 ed f8 d5 db 49 86 18
a-015.mkv	 0c eb 14 29 b0 74 e7 98 57 7c b7 c8 e1 0c d4 0f
a-016.mkv	 52 0e e9 c0 24 3c c2 d9 87 35 bf 5c 93 51 d7 0e
a-017.mkv	 93 2b 48 33 87 99 e3 de 30 6b 38 d1 24 92 6d 96
a-018.mkv	 f7 1c 62 39 2a 7c 96 8b ef a5 5d 89 51 31 0f d2
a-019.mkv	 47 fe aa 8d 52 a4 fa ad b4 7f 63 90 15 f5 1e c1
a-020.mkv	 99 49 5b 56 e4 cb 84 db 55 56 38 7e 48 e0 0c 36
a-021.mkv	 0f 74 e8 2a 91 f6 f7 f3 cf 4f 1a 99 70 21 73 86
a-022.mkv	 69 80 54 ca cd f4 6c 37 b7 87 ac 76 df c3 c0 6e
a-023.mkv	 e3 a5 e5 cc 47 e9 bf ac 84 6f 53 ed 9e c6 3f f0
a-024.mkv	 fa 71 8f 9b 73 37 f5 5c 76 13 fd 98 bf aa b8 d4
a-025.mkv	 cd 23 c9 c1 c1 ab 39 5d c8 f9 d9 26 50 d6 ac 7d
a-026.mkv	 20 0f 02 75 4e 34 a5 2f e0 cc 85 b4 9a 28 b4 8f
}

names = %{lotus
let the stars fall down
i swear
my long forgotten cloistered sleep
everytime you kissed me
I reach for the sun
Distance
eternal blue
sayonara solitia
Kaze no Machi e
Toki no mukou maboroshi no sora
paradise regained
Credens justitiam
L.A.
Himeboshi
Duran Shoukan
Mezame
stone cold
Sweet Song
Hikari no Yukue
Parallel Hearts
Encore
everlasting song
zodical sign
maybe tomorrow
}.split("\n").unshift("Start")



# get times
arr = times.split(/\n/).map do |e|
	e.split("\t")[1]
end.map { |t| to_ms t }

ids = uid.split(/\n/).collect do |e|
	e.split("\t")[1]
end.map { |e| e.strip }

# Normalise
(1..arr.length-1).each do |i|
	arr[i] = arr[i-1] + arr[i]
end

# debug
# p arr.map { |e| to_hh_mm_ss_ms e }

# get chapter start and end
chapter_times = []
arr[0..-2].each_with_index do |min, i|
	chapter_times << [min+5, arr[i+1] ]
end 

# add begining chapter
chapter_times.unshift [0,arr[0]]


def make_chapter_xml(id,arr,name)
	return %{
    <ChapterAtom>
        <ChapterUID>#{SecureRandom.random_number(8e8.to_i) + 1e8.to_i}</ChapterUID>
        <ChapterTimeStart>#{to_hh_mm_ss_ms arr[0]}</ChapterTimeStart>
        <ChapterTimeEnd>#{to_hh_mm_ss_ms arr[1]}</ChapterTimeEnd>
        <ChapterFlagHidden>0</ChapterFlagHidden>
        <ChapterFlagEnabled>1</ChapterFlagEnabled>
        <ChapterSegmentUID format="hex">
        #{id}
        </ChapterSegmentUID>
        <ChapterDisplay>
            <ChapterString>#{name}</ChapterString>
            <ChapterLanguage>eng</ChapterLanguage>
        </ChapterDisplay>
    </ChapterAtom>
	}
end


chapter_xml = chapter_times.zip(ids,names).map do |ar,id,name|
	make_chapter_xml(id,ar,name)
end


puts chapter_xml