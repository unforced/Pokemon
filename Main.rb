require_relative 'Move.rb'
require_relative 'Pokemon.rb'
require_relative 'Battle.rb'

puts "What is the first trainers name?"
p1nick = gets.chomp
puts "What is the first pokemons name?"
p1name = gets.chomp
puts "What level is it?"
p1level = gets.chomp.to_i
puts "What is the second trainers name?"
p2nick = gets.chomp
puts "What is the second pokemons name?"
p2name = gets.chomp
puts "What level is it?"
p2level = gets.chomp.to_i

p1 = eval("#{p1name.gsub(/\W/,'').downcase.capitalize}.new(#{p1level})")
p2 = eval("#{p2name.gsub(/\W/,'').downcase.capitalize}.new(#{p2level})")

battle = Battle.new(p1nick, p2nick, p1, p2)
until battle.finished
	puts "#{battle.turn.class} choose a move:"
	puts battle.get_moves
	puts battle.fight(gets.chomp.to_i)
end
