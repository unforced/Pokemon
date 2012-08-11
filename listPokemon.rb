require 'json'
require 'open-uri'
require 'nokogiri'
doc = Nokogiri::HTML(open('http://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_base_stats'))
rows = doc.css('.sortable.roundy').first.children.css('tr')[1..-1]
pokemonList = []
rows.each do |row|
	tds = row.children.css('td')
	pokemon = {}
	pokemon[:number] = tds[0].content.strip
	next if pokemonList.any?{|p| p[:number] == pokemon[:number]}
	link = tds[1].children[1].children.first.attributes['href'].value
	pokemon[:name] = tds[2].content.strip.sub(/ \(.*$/, '')
	pokemon_doc = Nokogiri::HTML(open("http://bulbapedia.bulbagarden.net#{link}"))
	type_table = pokemon_doc.css('#mw-content-text > table.roundy').first.xpath('./tr')[2].xpath('./td').first.css('table.roundy table.roundy').css('tr > td').first
	pokemon[:types] = type_table.css('span span').collect{|t| t.content.gsub(/\W/, '')}
	pokemon[:hp] = tds[3].content.strip
	pokemon[:attack] = tds[4].content.strip
	pokemon[:defense] = tds[5].content.strip
	pokemon[:spattack] = tds[6].content.strip
	pokemon[:spdefense] = tds[7].content.strip
	pokemon[:speed] = tds[8].content.strip
	potential_movetables = pokemon_doc.css('#mw-content-text > table.roundy')
	movetable = nil
	potential_movetables.each do |potential_movetable|
		if potential_movetable.children.css('table.sortable').any?
			movetable = potential_movetable
			break
		end
	end
	moverows = movetable.children.css('table.sortable').children.css('tr')[0..-1] if movetable
	if moverows
		if moverows[0].children.css('th')[1].content.strip.gsub(/\W/, '') == 'Move'
			col_num = 1
		elsif moverows[0].children.css('th')[2].content.strip.gsub(/\W/, '') == 'Move'
			col_num = 2
		end
	end
	pokemon[:moves] = moverows[1..-1].collect{|moverow| ":#{moverow.children.css('td')[col_num].content.strip.downcase.gsub(/\W/,'')}"} if moverows && col_num
	pokemon[:moves] ||= []
	pokemonList << pokemon
	puts "Finished #{pokemon[:name]}"
end

writeFile = open('copyPastaPokemon.rb','w')
pokemonList.each do |pokemon|
	writeFile.puts("class #{pokemon[:name].gsub(/\W/,'').downcase.capitalize} < Pokemon")
	writeFile.puts("name '#{pokemon[:name].to_s}'")
	writeFile.puts("number #{pokemon[:number]}")
	writeFile.puts("types #{pokemon[:types].collect{|t| ":#{t.downcase}"}.join(', ')}")
	writeFile.puts("basehp #{pokemon[:hp]}")
	writeFile.puts("baseattack #{pokemon[:attack]}")
	writeFile.puts("basedefense #{pokemon[:defense]}")
	writeFile.puts("basespattack #{pokemon[:spattack]}")
	writeFile.puts("basespdefense #{pokemon[:spdefense]}")
	writeFile.puts("basespeed #{pokemon[:speed]}")
	writeFile.puts("moves #{pokemon[:moves].join(", ")}")
	writeFile.puts("end")
end
