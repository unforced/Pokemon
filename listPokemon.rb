require 'json'
require 'open-uri'
require 'nokogiri'
require 'RMagick'
include Magick
doc = Nokogiri::HTML(open('http://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_base_stats'))
rows = doc.css('.sortable.roundy').first.children.css('tr')[1..-1]
pokemonList = {}
rows.each do |row|
	tds = row.children.css('td')
	pokemon = {}
	pokemon[:number] = tds[0].content.strip
	next if pokemonList.any?{|k,v| v[:number] == pokemon[:number]}
	link = tds[1].children[1].children.first.attributes['href'].value
	image = tds[1].children[1].children.first.children.first.attributes['src'].value
	pokemon[:name] = tds[2].content.strip.sub(/ \(.*$/, '')
	begin
		pokemon_doc = Nokogiri::HTML(open("http://bulbapedia.bulbagarden.net#{link}"))
	rescue OpenURI::HTTPError
		retry
	end
	type_table = pokemon_doc.css('#mw-content-text > table.roundy').first.xpath('./tr')[2].xpath('./td').first.css('table.roundy table.roundy').css('tr > td').first
	pokemon[:types] = type_table.css('span span').collect{|t| t.content.downcase.gsub(/\W/, '')}
	pokemon[:hp] = tds[3].content.strip.to_i
	pokemon[:attack] = tds[4].content.strip.to_i
	pokemon[:defense] = tds[5].content.strip.to_i
	pokemon[:spattack] = tds[6].content.strip.to_i
	pokemon[:spdefense] = tds[7].content.strip.to_i
	pokemon[:speed] = tds[8].content.strip.to_i
	pokemon[:ascii] = `ruby ascify.rb #{image}`
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
	pokemon[:moves] = moverows[1..-1].collect{|moverow| "#{moverow.children.css('td')[col_num].content.strip.downcase.gsub(/\W/,'')}"}.uniq if moverows && col_num
	pokemon[:moves] ||= []
	pokemonList[pokemon[:name].downcase.gsub(/\W/, '')] = pokemon
	puts "Finished #{pokemon[:name]}"
	puts pokemon[:ascii]
end

writeFile = open('copyPastaPokemon.json','w')
writeFile.puts(JSON.generate(pokemonList))
