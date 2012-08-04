class Battle
	attr_accessor :turn, :notTurn, :pokemon1, :pokemon2, :finished

	def initialize(nick1, nick2, pokemon1=nil, pokemon2=nil)
		@nick1 = nick1
		@nick2 = nick2
		@pokemon1 = pokemon1
		@pokemon2 = pokemon2
		@turn = @pokemon1
		@notTurn = @pokemon2
		@finished = false
	end

	def set_pokemon(nick, pokemon_name, pokemon_level)
		begin
			pokemon = eval("#{pokemon_name.gsub(/\W/,'').downcase.capitalize}.new(#{pokemon_level.to_i})")
		rescue NameError
			return "That is not a valid pokemon"
		end
		if nick==@nick1
			@pokemon1 = pokemon
			@turn = @pokemon1
		elsif nick==@nick2
			@pokemon2 = pokemon
			@notTurn = @pokemon2
		else
			return "You are not part of this battle"
		end
		message = "You have selected a level #{pokemon.level} #{pokemon.name}"
		message += "Both players have selected pokemon. #{@nick1} goes first." if @pokemon1 && @pokemon2
		return message
	end

	def get_pokemon(nick)
		return @pokemon1 if nick==@nick1
		return @pokemon2 if nick==@nick2
	end

	def get_moves(nick=nil)
		return get_pokemon(nick).list_moves if nick
		return @turn.list_moves
	end

	def fight(moveNumber, nick=nil)
		return "#{nick} && #{get_pokemon(nick).inspect} && #{@turn.inspect}" if nick && get_pokemon(nick) != @turn
		message = @turn.fight(moveNumber, @notTurn)
		if @notTurn.hp <= 0
			@finished = true
			return message + "\nThe pokemon has fainted"
		else
			@turn, @notTurn = @notTurn, @turn
			return message
		end
	end
end

