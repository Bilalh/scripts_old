tell application "iTunes"
	activate
	try
		
		
		--display dialog "Generating album list. One momentÉ" buttons {"¥"} default button 1 giving up after 1
		
		set the masterList to {}
		set theSelection to the selection of browser window 1
		repeat with i from 1 to the count of theSelection
			set the end of the masterList to the album of item i in theSelection
		end repeat
		
		set the albumList to {}
		repeat with i from 1 to the count of the masterList
			set thisAlbum to (item i of the masterList) as string
			if the albumList does not contain thisAlbum and Â
				thisAlbum is not "" then
				set the end of the albumList to thisAlbum
			end if
		end repeat
		
		--		display dialog "Sorting the album list. One momentÉ" buttons {"¥"} default button 1 giving up after 1
		set the albumList to my ASCII_Sort(albumList)
		set firstAlbum to (choose from list albumList with prompt "Pick the first album:") as string
		if firstAlbum is "false" then error number -128
		set secondAlbum to (choose from list albumList with prompt "Pick the second album:") as string
		if secondAlbum is "false" then error number -128
		display dialog "Enter the name of the album:" default answer firstAlbum
		set finalName to the text returned of the result
		
		set albumOne to (every track of library playlist 1 whose album is firstAlbum)
		set albumTwo to (every track of library playlist 1 whose album is secondAlbum)
		set theNum to the count of albumOne
		repeat with i from 1 to the count of albumTwo
			tell item i in albumTwo
				set the track number to theNum + 1
				set the album to finalName
			end tell
			set theNum to theNum + 1
		end repeat
		set theNum to 1
		repeat with i from 1 to the count of albumOne
			tell item i in albumOne
				set the track number to theNum
				set the album to finalName
			end tell
			set theNum to theNum + 1
		end repeat
		
		
		display dialog "Process completed." buttons {"¥"} default button 1 giving up after 2
	on error error_message number error_number
		if the error_number is not -128 then
			beep
			display dialog error_message buttons {"Cancel"} default button 1
		end if
	end try
end tell

on ASCII_Sort(my_list)
	set the index_list to {}
	set the sorted_list to {}
	repeat (the number of items in my_list) times
		set the low_item to ""
		repeat with i from 1 to (number of items in my_list)
			if i is not in the index_list then
				set this_item to item i of my_list as text
				if the low_item is "" then
					set the low_item to this_item
					set the low_item_index to i
				else if this_item comes before the low_item then
					set the low_item to this_item
					set the low_item_index to i
				end if
			end if
		end repeat
		set the end of sorted_list to the low_item
		set the end of the index_list to the low_item_index
	end repeat
	return the sorted_list
end ASCII_Sort