require 'Move.rb'
require 'Pokemon.rb'
require 'Battle.rb'

puts "What is the first pokemons name?"
p1name = gets.chomp
puts "What level is it?"
p1level = gets.chomp.to_i
puts "What is the second pokemons name?"
p2name = gets.chomp
puts "What level is it?"
p2level = gets.chomp.to_i

p1 = eval("#{p1name}.new(#{p1level})")
p2 = eval("#{p2name}.new(#{p2level})")

battle = Battle.new(p1, p2)
dead = false
until dead
puts "#{battle.turn.class} choose a move:"
battle.get_moves
dead = battle.fight(gets.chomp.to_i)
end
