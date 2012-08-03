load 'Move.rb'
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
		@hp += @level
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
		@moves.length.times.collect {|i| "#{i}: #{@moves[i].name}" if @moves[i]}.compact.join("\n")
	end

	def self.add_move(move)
		@moves ||= []
		@moves << move if move and move.power!='--'
	end

	def remove_move(moveNumber)
		@moves.delete_at(moveNumber)
	end

	def fight(moveNumber, opponentPokemon)
		move = moves[moveNumber]	
		c = rand(5)==0 ? 2 : 1
		a = attack
		d = opponentPokemon.defense
		r = rand(217..255)
		m = 1.0
		message = ''
		if c==2
			message += "It was a critical hit! "
		end
		if move.type == type
			m *= 1.5
		end
		if $types[move.type][0].include?(opponentPokemon.type)
			m *= 2
			message += "It was super effective! "
		elsif $types[move.type][1].include?(opponentPokemon.type)
			m *= 0.5
			message += "It was not very effective. "
		elsif $types[move.type][2].include?(opponentPokemon.type)
			m *= 0
			message += "It had no effect. "
		end
		movePower = (((((level * 0.4 * c) + 2.0) * (a.to_f / d.to_f) * (move.power / 50.0)) + 2.0) * m * r / 255.0).floor
		if move.accuracy != '--' and rand(1..100) > ((move.accuracy * accuracy)/100.0)
			return "You missed."
		else
			opponentPokemon.hp -= movePower
			return "#{message}#{name} dealt #{movePower} damage to #{opponentPokemon.name}"
		end
	end
end
load "copyPastaPokemon.rb"
