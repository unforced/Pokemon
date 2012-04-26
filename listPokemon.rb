require 'open-uri'
s = open('http://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_base_stats_(Generation_I)').read
searchName = "(Pok\303\251mon)\">"
searchLink = "a href=\""
searchHP = "background:#FF5959\"> "
searchAttack = "background:#F5AC78\"> "
searchDefense = "background:#FAE078\"> "
searchSpeed = "background:#FA92B2\"> "
searchSpecial = "background:#94EFE0\"> "
searches = [searchHP,searchAttack,searchDefense,searchSpeed,searchSpecial]
position1=0
position2=s.index("(Pok%C3%A9mon)")
pokemonList = []
while s.index(searchName,position2)
	pokemon = []
	position1 = s.index(searchLink,position2)+searchLink.length
	position2 = s.index("\"",position1)
	pokemon << "http://bulbapedia.bulbagarden.net" + s[position1...position2] + "/Generation_I_learnset"
	position1 = s.index(searchName,position2)+searchName.length
	position2 = s.index("<",position1)
	pokemon << s[position1...position2]
	searches.each do |search|
		position1 = s.index(search,position2)+search.length
		position2 = s.index("\n",position1)
		pokemon << s[position1...position2]
	end
	pokemonList << pokemon
end
writeFile = open('copyPasta.rb','w')
pokemonList.each do |pokemon|
	begin
		m = open(pokemon[0]).read
	rescue Exception
		20.times {puts "ERROR"}
		puts "ERROR #{pokemon[0]}"
		retry
	end
	searchMove = "(move)\"><span style=\"color:#000;\">"
	searchPower = "#D8D8D8;\"> "
	badMove = "&#8212;"
		writeFile.puts("class #{pokemon[1].gsub(/\W/,'').downcase.capitalize} < Pokemon")
	writeFile.puts("name \"#{pokemon[1].to_s}\"")
	moves=[]
	position1 = 0
	position2 = 0
	while m.index(searchMove, position2)
		position1 = m.index(searchMove, position2)+searchMove.length
		position2 = m.index("</span>",position1)
		moveName = ":#{m[position1...position2].downcase.gsub(/[^a-z]/,'')}"
		position1 = m.index(searchPower, position2)+searchPower.length
		position2 = m.index("\n", position1)
		movePower = m[position1...position2]
		moves << moveName if movePower != badMove and !moves.include?moveName
	end
	begin
		site = open("http://pokemon.wikia.com/wiki/#{pokemon[1]}").read
		search = "<b>Type(s):</b>"
		a = site.index(search)
		b = site.index('title="',a)
		c = site.index('Pok',b)
		type = site[b+7...c-1].downcase
		writeFile.puts("type :#{type}")
	rescue Exception
		writeFile.puts("type nil")
	end
	writeFile.puts("basehp #{pokemon[2]}")
	writeFile.puts("baseattack #{pokemon[3]}")
	writeFile.puts("basedefense #{pokemon[4]}")
	writeFile.puts("basespattack #{pokemon[6]}")
	writeFile.puts("basespdefense #{pokemon[6]}")
	writeFile.puts("basespeed #{pokemon[5]}")
	writeFile.puts("moves #{moves.join(", ")}")
	writeFile.puts("end")
	puts "Finished #{pokemon[1]}"
end
