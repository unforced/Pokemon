"""
I saw something on DailyWTF about how someone tested new programmers by having them write rom2num
Apparently most people had a hard time with it and one answer was particularly ridiculous.
So I tried writing it myself.
Requires roman numerals to be entered in the standard way(VIII, not IIX).
"""
def rom2num(rom)
	num = 0
	last_num = 0
	roman_numerals = {'I' => 1, 'V' => 5, 'X' => 10, 'L' => 50, 'C' => 100, 'D' => 500, 'M' => 1000}
	rom.upcase.reverse.each_char do |char|
		value = roman_numerals[char]
		if value >= last_num
			num += value
		else
			num -= value
		end
		last_num = value
	end
	return num
end
