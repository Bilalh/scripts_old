tell application "iTunes" to set tt to {player position} & {duration} of current track


set cMin to (1st item of tt) div 60
set cSec to (1st item of tt) mod 60
set tMin to (2nd item of tt) div 60
set tSec to (2nd item of tt) mod 60


set cur to cMin & ":" & zero_pad(cSec, 2) & "/" & tMin & ":" & zero_pad(tSec, 2) as string

on zero_pad(value, string_length)
	set tmp_string to "000000000" & (value as string)
	set padded_value to characters ((length of tmp_string) - string_length + 1) thru -1 of tmp_string as string
	return padded_value
end zero_pad