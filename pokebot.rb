module Cinch
	module Plugins
		class Pokebot
			require_relative 'Move.rb'
			require_relative 'Pokemon.rb'
			require_relative 'Battle.rb'
			include Cinch::Plugin

			def initialize(*args)
				super
				@battle = nil
			end

			match /^!poke/, :method => :execute

			def execute(m)
				text = m.params[1][6..-1]
				command = text.split[0]
				args = text.split[1..-1]
				handle(m, command, args, m.user.nick)
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
					message.reply no_command
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
				return @battle.set_pokemon(nick, name, level)
			end

			def get_moves(nick)
				return @battle.get_pokemon(nick).list_moves
			end

			def attack(nick, move)
				if @battle.pokemon1.nil? || @battle.pokemon2.nil?
					return "Both players must choose their pokemon first."
				end
				message = @battle.fight(move.to_i, nick)
				if @battle.finished
					@battle = nil
				end
				return message
			end

			def commands
				return ["!poke newgame [Opponent_nick]", "!poke choose [Pokemon_name] [Pokemon_level]",
					"!poke getmoves", "!poke attack [Move_number]", "!poke quitgame"].join("\n")
			end

			def no_command
				return "Sorry, that is not a valid command.  Use '!poke commands'"
			end
		end
	end
end
