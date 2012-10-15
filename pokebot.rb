class Object
	def is_numeric?
		true if Float(self) rescue false
	end
end

module Cinch
	module Plugins
		class Pokebot
			require_relative 'Move.rb'
			require_relative 'Pokemon.rb'
			require_relative 'Battle.rb'
			require_relative 'Trainer.rb'
			include Cinch::Plugin

			def initialize(*args)
				super
				@battle = nil
			end

			match /[!@]poke/, :method => :execute

			def execute(m)
				send_all = (m.params[1] =~ /!poke/).nil?
				text = m.params[1].sub(/.*[!@]poke /, '')
				command = text.split[0]
				args = text.split[1..-1]
				handle(m, command, args, m.user, send_all)
			end

			def handle(message, command, args, user, send_all)
				case command
				when 'newgame'
					new_game(message, user, args[0], args[1], args[2])
				when 'quitgame'
					quit_game(message, user, send_all)	
				when 'whosturn'
					whos_turn(message)
				when 'choose'
					choose_pokemon(message, user, *args)
				when 'getmoves'
					get_moves(user, send_all)
				when 'attack'
					attack(message, user, args[0], send_all)
				when 'commands'
					commands(user, send_all, message)
				when 'listpokemon'
					list_pokemon(user, args[0], send_all)
				when 'ascii'
					ascii(message, user, args[0], send_all)
				else
					no_command(user)
				end
			end

			def ascii(message, user, pokemon_name, send_all)
				ascii = Pokemon.new(pokemon_name).ascii
				if send_all
					message.channel.send(ascii)
				else
					user.send(ascii)
				end
			end

			def new_game(message, user1, nick2, poke_count, default_level)
				if !message.channel
					return user1.notice "You must start a game from a channel"
				end
				@channel = message.channel
				poke_count = poke_count.to_i if poke_count
				default_level = default_level.to_i if default_level
				poke_count ||= 1 
				if poke_count <= 0 || poke_count > 6
					user1.notice "You must select between 1 and 6 pokemon for the battle."
				elsif default_level && (default_level <= 0 || default_level > 100)
					user1.notice "Default level must be between 0 and 100"
				elsif self.bot.user_list.find(nick2).nil?
					user1.notice "#{nick2} is not in this channel."
				else
					@battle = Battle.new(Trainer.new(user1.nick), Trainer.new(nick2), default_level, poke_count)	
					@channel.send "#{poke_count} pokemon battle started between #{user1.nick} and #{nick2}, trainers please select your pokemon."
				end
			end

			def quit_game(message, user, send_all)
				if @battle && @battle.trainer1 && @battle.trainer2
					user1 = self.bot.user_list.find(@battle.trainer1.nick)
					user2 = self.bot.user_list.find(@battle.trainer2.nick)
					if ![user1, user2].include?(user)
						user.notice "You can not end a game you are not part of."
					else
						@battle = nil
						if send_all
							@channel.send("The game has ended")
						else
							[user1, user2].each{|u| u.notice("The game has ended")}
						end
					end
				end
			end

			def choose_pokemon(message, user, *args)
				trainer = @battle.get_trainer(user.nick)
				if !trainer
					user.notice "You are not part of this game."
				elsif @battle.level 
					if args.any?{|a| a.is_numeric?}
						user.notice "You can not specify a level if a default level has been set"
					elsif args.count != @battle.pokemon_count
						user.notice "You must select exactly #{@battle.pokemon_count} pokemon."
					else
						begin
							args.each{|p| @battle.set_pokemon(trainer, p)}
						rescue ArgumentError
							return user.notice "You selected an invalid pokemon."
						end
						@channel.send "#{user.nick} has selected his pokemon."
					end
				else
					if args.count != @battle.pokemon_count*2
						user.notice "You must select exactly #{@battle.pokemon_count} pokemon with a level for each."
					else
						until args.empty?
							name = args.shift
							level = args.shift
							return user.notice("Please ensure all levels are between 0 and 100, #{level}") unless level.is_numeric?
							level = level.to_i
							begin
								@battle.set_pokemon(trainer, name, level)
							rescue ArgumentError
								return user.notice "You selected an invalid pokemon."
							end
							@channel.send "#{user.nick} has selected his pokemon"
						end
					end
				end
			end

			def get_moves(user, send_all)
				if @battle.get_trainer(user.nick)
					m = @battle.get_pokemon(user.nick).list_moves
					if send_all
						@channel.send m
					else
						user.notice m
					end
				else
					user.notice "You are not in the battle."
				end
			end

			def attack(message, user, move, send_all)
				if @battle.ready
					return @channel.send "Both players must choose their pokemon first."
				end
				if @battle.get_trainer(user.nick) != @battle.turn
					return user.notice("It's not your turn.")
				end
				message = @battle.fight(move.to_i, user.nick)
				user1 = self.bot.user_list.find(@battle.trainer1.nick)
				user2 = self.bot.user_list.find(@battle.trainer2.nick)
				if send_all
					@channel.send message
				else
					[user1,user2].each{|u| u.notice(message)}
				end
				if @battle.finished
					@battle = nil
				end
			end

			def list_pokemon(user, nick, send_all)
				if nick
					trainer = @battle.get_trainer(nick)
				else
					trainer = @battle.get_trainer(user.nick)
				end
				if send_all
					@channel.send trainer.list_pokemon(trainer.alive_pokemon)
				else
					user.notice trainer.list_pokemon(trainer.alive_pokemon)
				end
			end

			def commands(user, send_all, message)
				msg = ["!poke newgame [Opponent_nick] [pokemon_count] [default_level]", "!poke choose [Pokemon_name [Pokemon_level]] [Pokemon_name [Pokemon_level]] etc...", "!poke getmoves", "!poke listpokemon [username]", "!poke whosturn", "!poke attack [Move_number]", "!poke quitgame"].join("\n")
				if send_all
					message.channel.send msg
				else
					user.notice msg
				end
			end

			def no_command(user)
				user.notice "Sorry, that is not a valid command.  Use '!poke commands'"
			end

			def whos_turn(message)
				@channel.send "It is #{@battle.turn.nick}'s turn"
			end
		end
	end
end
