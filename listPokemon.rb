require 'open-uri'
s = open('listOfPokemon.html').read
searchName = "(Pok\303\251\mon)\">"
searchHP = "background:#FF5959\"> "
searchAttack = "background:#F5AC78\"> "
searchDefense = "background:#FAE078\"> "
searchSpeed = "background:#FA92B2\"> "
searchSpecial = "background:#94EFE0\"> "
searches = [searchHP,searchAttack,searchDefense,searchSpeed,searchSpecial]
position1=0
position2=0
pokemonList = []
while s.index(searchName,position2)
	pokemon = []
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
	writeFile.puts("class #{pokemon[0]} < Pokemon")
	begin
	site = open("http://pokemon.wikia.com/wiki/#{pokemon[0]}").read
	search = "<b>Type(s):</b>"
	a = site.index(search)
	b = site.index('title="',a)
	c = site.index('Pok',b)
	type = site[b+7...c-1].downcase
	writeFile.puts("type :#{type}")
	rescue Exception
		writeFile.puts("type nil")
	end
	writeFile.puts("basehp #{pokemon[1]}")
	writeFile.puts("baseattack #{pokemon[2]}")
	writeFile.puts("basedefense #{pokemon[3]}")
	writeFile.puts("basespattack #{pokemon[5]}")
	writeFile.puts("basespdefense #{pokemon[5]}")
	writeFile.puts("basespeed #{pokemon[4]}")
	writeFile.puts("moves nil")
	writeFile.puts("end")
end

