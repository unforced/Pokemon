require 'json'
$moves = JSON.parse(open('copyPastaMoves.json').read, :symbolize_names => true)
class Move
	attr_accessor :pp
	attr_reader :type, :power, :name, :accuracy, :category

	$types = {
		:normal => [[],[:rock,:steel],[:ghost]],
		:fighting => [[:normal,:rock,:ice,:steel,:dark],[:flying,:poison,:bug,:psychic],[:ghost]],
		:flying => [[:fighting,:bug,:grass],[:rock,:electric,:steel],[]],
		:poison => [[:grass],[:poison,:ground,:rock,:ghost],[:steel]],
		:ground => [[:poison,:rock,:fire,:electric,:steel],[:bug,:grass],[:flying]],
		:rock => [[:flying,:bug,:fire,:ice],[:fighting,:ground,:steel],[]],
		:bug => [[:grass,:psychic,:dark],[:poison,:fighting,:flying,:ghost,:fire,:steel],[]],
		:ghost => [[:ghost,:psychic],[:steel],[:normal]],
		:steel => [[:rock,:ice],[:steel,:fire,:water,:electric],[]],
		:fire => [[:bug,:grass,:ice,:steel],[:rock,:fire,:water,:dragon],[]],
		:water => [[:ground,:rock,:fire],[:water,:grass,:dragon],[]],
		:grass => [[:ground,:rock,:water],[:flying,:poison,:bug,:fire,:grass,:dragon,:steel],[]],
		:electric => [[:flying,:water],[:grass,:electric,:dragon],[:ground]],
		:psychic => [[:fighting,:poison],[:psychic,:steel],[:dark]],
		:ice => [[:flying,:ground,:grass,:dragon],[:water,:ice,:fire,:steel],[]],
		:dragon => [[:dragon],[:steel],[]],
		:dark => [[:ghost,:psychic],[:fighting,:steel,:dark],[]]
	}

	def initialize(name)
		move = $moves[name.downcase.gsub(/\W/, '').to_sym]
		@name = move[:name]
		@type = move[:type].to_sym
		@category = move[:category].to_sym
		@pp = move[:pp]
		@power = move[:power]
		@accuracy = move[:accuracy]
	end
end
