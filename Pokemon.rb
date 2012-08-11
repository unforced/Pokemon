class Pokemon
	attr_accessor :name, :hp, :attack, :defense, :spattack, :spdefense, :speed, :accuracy
	attr_reader :moves, :level
	def initialize(name, level=1)
		@name = name
		@level = level
		pokemon = $pokemon[name]
		return "That pokemon does not exist" if pokemon.nil?
		@hp = pokemon[:hp]+level
		@attack = pokemon[:attack]+level
		@defense = pokemon[:defense]+level
		@spattack = pokemon[:spattack]+level
		@spdefense = pokemon[:spdefense]+level
		@speed = pokemon[:speed]+level
		@accuracy = pokemon[:accuracy]+level
		@moves = pokemon[:moves].collect{|m| Move.new(m)}
	end

	def list_moves
		@moves.length.times.collect {|i| "#{i}: #{@moves[i].name}" if @moves[i]}.compact.join("\n")
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
require_relative "copyPastaPokemon.rb"
