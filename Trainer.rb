class Trainer
	attr_accessor :pokemon_list, :nick, :active_pokemon

	def initialize(nick, pokemon_list=[])
		@nick = nick
		@pokemon_list = pokemon_list
		@active_pokemon = @pokemon_list.first
	end

	def add_pokemon(*args)
		args.each do |pokemon|
			@pokemon_list << pokemon
		end
		@active_pokemon = @pokemon_list.first
	end

	def list_pokemon(pokemans=@pokemon_list)
		return pokemans.collect{|p| "#{p.name}, level:#{p.level}, hp:#{p.hp}/#{p.maxhp}"}.join("\n")
	end

	def alive_pokemon
		return @pokemon_list.select{|p| p.hp > 0}
	end
end
