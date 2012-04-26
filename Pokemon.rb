require 'Move.rb'
class Pokemon
	attr_accessor :name, :hp, :attack, :defense, :spattack, :spdefense, :speed, :accuracy
	attr_reader :moves, :level
	def initialize(level=1)
		@level = level
		self.class.traits.each do |k,v|
			instance_variable_set("@#{k}",v)
		end
		@@stats.each do |stat|
			instance_variable_set("@#{stat}",eval("@base#{stat}+@level"))
		end
		@accuracy = 100
		@moves = self.class.moves
	end

	def self.metaclass
		class << self
			self
		end
	end

	def self.moves(*arr)
		arr.each do |movetext|
			add_move($moves[movetext])
		end
		@moves
	end

	def self.traits(*arr)
		return @traits if arr.empty?
		attr_reader *arr
		arr.each do |a|
			metaclass.instance_eval do
				define_method(a) do |val|
					@traits ||= {}
					@traits[a] = val
				end
			end
		end
	end

	@@stats = :hp, :attack, :defense, :spattack, :spdefense, :speed
	traits :basehp, :baseattack, :basedefense, :basespattack, :basespdefense, :basespeed, :type, :name 

	def list_moves
		@moves.length.times {|i| puts "#{i}: #{@moves[i].name}" if @moves[i]}
	end

	def self.add_move(move)
		@moves ||= []
		@moves << move
	end

	def remove_move(moveNumber)
		@moves.delete_at(moveNumber)
	end

	def fight(moveNumber, opponentPokemon)
		move = moves[moveNumber]	
		movePower = move.power
		movePower *= attack
		movePower /= opponentPokemon.defense
		movePower = rand(movePower)
		puts move.accuracy == '--'
		if move.accuracy != '--' and rand(101) > ((move.accuracy * accuracy)/100.0)
			puts "You missed."
		else
			if rand(5) == 0
				movePower *= 2
				print "It was a critical hit! "
			end
			if $types[move.type][0].include?opponentPokemon.type
				movePower *= 2
				print "It was super effective! "
			elsif $types[move.type][1].include?opponentPokemon.type
				movePower *= 0.5
				print "It was not very effective. "
			elsif $types[move.type][2].include?opponentPokemon.type
				movePower *= 0
				print "It had no effect. "
			end
			puts "#{name} dealt #{movePower} damage to #{opponentPokemon.name}"
			opponentPokemon.hp -= movePower
			if opponentPokemon.hp <= 0
				puts "#{opponentPokemon.name} has died"
				return true
			end
		end
		false
	end
end
load("copyPastaPokemon.rb")
