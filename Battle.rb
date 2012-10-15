class Battle
	attr_accessor :turn, :notTurn, :trainer1, :trainer2, :finished, :level, :pokemon_count, :ready

	def initialize(trainer1, trainer2, level=nil, pokemon_count=1)
		@trainer1 = trainer1
		@trainer2 = trainer2
		@turn = @trainer1
		@notTurn = @trainer2
		@level = level
		@pokemon_count = pokemon_count
		@finished = false
		@ready = false
	end

	def set_pokemon(trainer, pokemon_name, pokemon_level=@level)
		pokemon = Pokemon.new(pokemon_name, pokemon_level)
		trainer.add_pokemon(pokemon)
		@ready = (@trainer1.pokemon_list == pokemon_count && @trainer2.pokemon_list == pokemon_count)
	end
	
	def get_trainer(nick)
		return @trainer1 if @trainer1.nick == nick
		return @trainer2 if @trainer2.nick == nick
	end
	
	def get_pokemon(nick)
		return get_trainer(nick).active_pokemon
	end

	def get_moves(nick=nil)
		return get_pokemon(nick).list_moves if nick
		return @turn.active_pokemon.list_moves
	end

	def fight(moveNumber, nick=nil)
		attacker = @turn.active_pokemon
		defender = @notTurn.active_pokemon
		message = attacker.fight(moveNumber, defender)
		if defender.hp <= 0
			message += "\nThe pokemon has fainted"
			@notTurn.active_pokemon = @notTurn.alive_pokemon.first
			message += "\n#{@notTurn.nick} has sent out #{@notTurn.active_pokemon.name}" if @notTurn.active_pokemon
		end
		if @notTurn.alive_pokemon.count <= 0
			@finished = true
			message += "\n#{@turn.nick} has won."
		end
		@turn, @notTurn = @notTurn, @turn
		return message
	end
end

