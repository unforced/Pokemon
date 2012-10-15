require 'json'
$pokemon = JSON.parse(open("copyPastaPokemon.json").read, :symbolize_names => true)
class Pokemon
	attr_accessor :name, :hp, :attack, :defense, :spattack, :spdefense, :speed, :accuracy
	attr_reader :moves, :level, :types, :maxhp, :ascii
	def initialize(name, level=1)
		@level = level
		pokemon = $pokemon[name.downcase.gsub(/\W/,'').to_sym]
		raise(ArgumentError, "That pokemon does not exist") if pokemon.nil?
		@ascii = pokemon[:ascii]
		@name = pokemon[:name]
		@hp = pokemon[:hp]+(level*2)
		@maxhp = pokemon[:hp]+(level*2)
		@types = pokemon[:types].collect{|t| t.to_sym}
		@attack = pokemon[:attack]+level
		@defense = pokemon[:defense]+level
		@spattack = pokemon[:spattack]+level
		@spdefense = pokemon[:spdefense]+level
		@speed = pokemon[:speed]+level
		@accuracy = 100
		@moves = pokemon[:moves].collect{|m| Move.new(m)}.select{|m| m.category != :status}.sample(4)
	end

	def list_moves
		@moves.length.times.collect {|i| "#{i}: #{@moves[i].name}, #{@moves[i].type}, #{@moves[i].category}, pp:#{@moves[i].pp}, power:#{@moves[i].power}, accuracy:#{@moves[i].accuracy}" if @moves[i]}.compact.join("\n")
	end

	def fight(moveNumber, opponentPokemon)
		move = moves[moveNumber]	
		move.pp -= 1
		c = rand(5)==0 ? 2 : 1
		a = attack
		d = opponentPokemon.defense
		r = rand(217..255)
		m = 1.0
		message = ''
		if c==2
			message += "It was a critical hit! "
		end
		if types.include?(move.type)
			m *= 1.5
		end
		opponentPokemon.types.each do |type|
			if $types[move.type][0].include?(type)
				m *= 2
				message += "It was super effective! "
			elsif $types[move.type][1].include?(type)
				m *= 0.5
				message += "It was not very effective. "
			elsif $types[move.type][2].include?(type)
				m *= 0
				message += "It had no effect. "
			end
		end
		movePower = (((((level * 0.4 * c) + 2.0) * (a.to_f / d.to_f) * (move.power / 50.0)) + 2.0) * m * r / 255.0).floor
		if move.accuracy != '--' and rand(1..100) > ((move.accuracy * accuracy)/100.0)
			return "You missed."
		else
			opponentPokemon.hp -= movePower
			return "#{message}#{name} used #{move.name} and dealt #{movePower} damage to #{opponentPokemon.name}"
		end
	end
end
