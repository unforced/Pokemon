require_relative 'Move.rb'
require_relative 'Pokemon.rb'
require_relative 'Battle.rb'
require_relative 'Trainer.rb'

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

battle = Battle.new(Trainer.new(p1nick), Trainer.new(p2nick))
battle.set_pokemon(battle.get_trainer(p1nick), p1name, p1level)
battle.set_pokemon(battle.get_trainer(p2nick), p2name, p2level)
battle.trainer1.active_pokemon = battle.trainer1.pokemon_list.first
battle.trainer2.active_pokemon = battle.trainer2.pokemon_list.first
until battle.finished
	puts "#{battle.turn.nick} choose a move:"
	puts battle.get_moves
	puts battle.fight(gets.chomp.to_i)
end
