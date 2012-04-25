class Battle
	attr_accessor :turn, :notTurn, :pokemon1, :pokemon2

	def initialize(pokemon1, pokemon2)
		@pokemon1 = pokemon1
		@pokemon2 = pokemon2
		@turn = @pokemon1
		@notTurn = @pokemon2
	end

	def get_moves
		@turn.list_moves
	end

	def fight(moveNumber)
		dead = @turn.fight(moveNumber, @notTurn)
		@turn, @notTurn = @notTurn, @turn
		return dead
	end
end

