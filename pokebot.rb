class Pokebot
	load 'Move.rb'
	load 'Pokemon.rb'
	load 'Battle.rb'
	include Cinch::Plugin

	@battle = nil

	match /^!poke/

		def execute(m)
			text = m.params[1][6..-1]
			command = text.split[0]
			args = text.split[1..-1]
			pokemon_handle(m, command, args, m.user.nick)
		end

	def handle(message, command, args, nick)
		case command
		when 'newgame'
			message.reply new_game(nick, args[0])
		when 'quitgame'
			message.reply quit_game(nick)	
		when 'choose'
			message.reply choose_pokemon(nick, args[0], args[1])
		when 'getmoves'
			message.reply get_moves(nick)
		when 'attack'
			message.reply attack(nick, args[0])
		when 'commands'
			message.reply commands
		else
			message.reply no_command(nick)
		end
	end

	def new_game(nick1, nick2)
		@battle = Battle.new(nick1, nick2)	
		return "Battle started between #{nick1} and #{nick2}, please choose your pokemon with '!poke choose pokemon_name pokemon_level'"
	end

	def quit_game(nick)
		@battle = nil
		return "Game ended"
	end

	def choose_pokemon(nick, name, level)
		@battle.set_pokemon(nick, eval("#{name.gsub(/\W/,'').downcase.capitalize}.new(#{level.to_i})"))
		return "Pokemon selected"
	end

	def get_moves(nick)
		return @battle.get_pokemon(nick).list_moves
	end

	def attack(nick, move)
		message = @battle.fight(move.to_i, nick)
		if @battle.finished
			@battle = nil
		end
		return message
	end

	def commands
		commands = ["!poke newgame [Opponent_nick]", "!poke choose [Pokemon_name] [Pokemon_level]", "!poke getmoves", "!poke attack [Move_nummber]", "!poke quitgame"]
	end

	def no_command(nick)
		return "Sorry, that is not a valid command.  Use '!poke commands'"
	end
end
