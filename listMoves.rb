require 'json'
require 'open-uri'
require 'nokogiri'
require_relative 'rom2num.rb'

doc = Nokogiri::HTML(open("http://bulbapedia.bulbagarden.net/wiki/List_of_moves"))
move_rows = doc.css('#mw-content-text').first.css('table.sortable.roundy table.sortable.roundy').first.children.css('tr')[1..-1]
moves = {}
move_rows.each do |row|
	move = {}
	tds = row.children.css('td')
	move[:name] = tds[1].content.strip
	move[:type] = tds[2].content.strip.downcase
	move[:category] = tds[3].content.strip.downcase
	move[:pp] = tds[5].content.strip.to_i
	move[:power] = tds[6].content.strip.to_i
	move[:accuracy] = tds[7].content.strip.chomp('%').to_i
	move[:generation] = rom2num(tds[8].content.strip.to_i)
	moves[move[:name].downcase.gsub(/\W/,'')] = move
end

write_file = open('copyPastaMoves.json', 'w')
write_file.puts(JSON.generate(moves))
