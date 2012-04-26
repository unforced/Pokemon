require 'open-uri'
s = open("http://bulbapedia.bulbagarden.net/wiki/List_of_moves").read
searchName = "(move)\">"
searchType = "color:#FFF;\">"
searchNumbers = "<td> "
searchCategory = Regexp.compile("color:#\\w*;\">")
position1 = 0
position2 = 0
moves = []
while s.index("165",position2)
	move = []
	[searchName,searchType].each do |search|
		position1 = s.index(search,position2)+search.length
		position2 = s.index("<",position1)
		move << s[position1...position2].chomp
	end
	position1 = s.index(searchCategory,position2)+s.match(searchCategory,position2)[0].length
	position2 = s.index("<",position1)
	move << s[position1...position2].chomp
	3.times do
		position1 = s.index(searchNumbers,position2)+searchNumbers.length
		position2 = s.index(/<|%/, position1)
		move << s[position1...position2].chomp
	end
	moves << move
end
f = open("copyPastaMoves.rb",'w')
f.puts("$moves = {")
moves.each do |move|
	move = move.collect do |i|
		if i==nil or i=='' or i=="&#8212;"
			"'--'"
		else
			i
		end
	end
	string = ":#{move[0].downcase.gsub(/\W/,'')} => Move.new(\"#{move[0]}\", :#{move[1].downcase}, :#{move[2].downcase}, #{move[3]}, #{move[4]}, #{move[5]}),"
	string = '#' + string if move[4] == "'--'"
	f.puts(string)
end
f.puts("}")
