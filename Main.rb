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

battle = Battle.new(p1nick, p2nick)
battle.set_pokemon(p1nick, p1name, p1level)
battle.set_pokemon(p2nick, p2name, p2level)
if battle.pokemon1 && battle.pokemon2
	until battle.finished
		puts "#{battle.turn.class} choose a move:"
		puts battle.get_moves
		puts battle.fight(gets.chomp.to_i)
	end
else
	puts "Someone tried to use a pokemon that does not exist(Only generation 1 are included)."
end
