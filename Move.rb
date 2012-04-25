class Move
	attr_reader :types, :type, :power, :name, :accuracy

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
		
	def initialize(name, type, power, accuracy)
		@type = type
		@power = power
		@name = name
		@accuracy = accuracy
	end

	#Multiple attack moves are on there, but they only hit once.
	#PP isnt added yet
	#No special effects are added in yet, project for another day
	#Moves with special effects are there, they just only do normal damage.
	#Moves that don't have a number for damage are left out.
	#Special vs Physical damage not used yet.
	$moves = {
		'pound' => Move.new('Pound', :normal, 40, 100),
		'karatechop' => Move.new('Karate Chop', :fighting, 50, 100),
		'doubleslap' => Move.new('DoubleSlap', :normal, 15, 85),
		'cometpunch' => Move.new('Comet Punch', :normal, 18, 85),
		'megapunch' => Move.new('Mega Punch', :normal, 80, 85),
		'payday' => Move.new('Pay Day', :normal, 40, 100),
		'firepunch' => Move.new('Fire Punch', :fire, 75, 100),
		'icepunch' => Move.new('Ice Punch', :ice, 75, 100),
		'thunderpunch' => Move.new('ThunderPunch', :electric, 75, 100),
		'scratch' => Move.new('Scratch', :normal, 40, 100),
		'vicegrip' => Move.new('ViceGrip', :normal, 55, 100),
		'razorwind' => Move.new('Razor Wind', :normal, 80, 100),
		'cut' => Move.new('Cut', :normal, 50, 95),
		'gust' => Move.new('Gust', :flying, 40, 100),
		'wingattack' => Move.new('Wing Attack', :flying, 60, 100),
		'fly' => Move.new('Fly', :flying, 90, 95),
		'bind' => Move.new('Bind', :normal, 15, 85),
		'slam' => Move.new('Slam', :normal, 80, 75),
		'vinewhip' => Move.new('Vine Whip', :grass, 35, 100),
		'stomp' => Move.new('Stomp', :normal, 65, 100),
		'doublekick' => Move.new('Double Kick', :fighting, 30, 100),
		'megakick' => Move.new('Mega Kick', :normal, 120, 75),
		'jumpkick' => Move.new('Jump Kick', :fighting, 100, 95),
		'rollingkick' => Move.new('Rolling Kick', :fighting, 60, 85),
		'headbutt' => Move.new('Headbutt', :normal, 70, 100),
		'hornattack' => Move.new('hornattack', :normal, 70, 100),
		'furyattack' => Move.new('Fury Attack', :normal, 15, 85),
		'tackle' => Move.new('Tackle', :normal, 50, 100),
		'bodyslam' => Move.new('Body Slam', :normal, 85, 100),
		'wrap' => Move.new('Wrap', :normal, 15, 90),
		'takedown' => Move.new('Take Down', :normal, 90, 85),
		'thrash' => Move.new('Thrash', :normal, 120, 100),
		'doubleedge' => Move.new('Double-Edge', :normal, 120, 100),
		'poisonsting' => Move.new('Poison Sting', :poison, 15, 100),
		'twineedle' => Move.new('Twineedle', :bug, 25, 100),
		'pinmissile' => Move.new('Pin MIssile', :bug, 14, 85),
		'bite' => Move.new('Bite', :dark, 60, 100),
		'acid' => Move.new('Acid', :poison, 40, 100),
		'ember' => Move.new('Ember', :fire, 40, 100),
		'flamethrower' => Move.new('Flamethrower', :fire, 95, 100),
		'watergun' => Move.new('Water Gun', :water, 40, 100),
		'hydropump' => Move.new('Hydro Pump', :water, 120, 80),
		'surf' => Move.new('Surf', :water, 95, 100),
		'icebeam' => Move.new('Ice Beam', :ice, 95, 100),
		'blizzard' => Move.new('Blizzard', :ice, 120, 70),
		'psybeam' => Move.new('Psybeam', :psychic, 65, 100),
		'bubblebeam' => Move.new('BubbleBeam', :water, 65, 100),
		'aurorabeam' => Move.new('Aurora Beam', :ice, 65, 100),
		'hyperbeam' => Move.new('Hyper Beam', :normal, 150, 90),
		'peck' => Move.new('Peck', :flying, 35, 100),
		'drillpeck' => Move.new('Drill Peck', :flying, 80, 100),
		'submission' => Move.new('Submission', :fighting, 80, 80),
		'strength' => Move.new('Strength', :normal, 80, 100),
		'absorb' => Move.new('Absorb', :grass, 20, 100),
		'megadrain' => Move.new('Mega Drain', :grass, 40, 100),
		'razorleaf' => Move.new('Razor Leaf', :grass, 55, 95),
		'solarbeam' => Move.new('SolarBeam', :grass, 120, 100),
		'petaldance' => Move.new('Petal Dance', :grass, 120, 100),
		'firespin' => Move.new('Fire Spin', :fire, 35, 85),
		'thundershock' => Move.new('ThunderShock', :electric, 40, 100),
		'thunderbolt' => Move.new('Thunderbolt', :electric, 95, 100),
		'thunder' => Move.new('Thunder', :electric, 120, 70),
		'rockthrow' => Move.new('Rock Throw', :rock, 50, 90),
		'earthquake' => Move.new('Earthquake', :ground, 100, 100),
		'dig' => Move.new('Dig', :ground, 80, 100),
		'confusion' => Move.new('Confusion', :psychic, 50, 100),
		'psychic' => Move.new('Psychic', :psychic, 90, 100),
		'quickattack' => Move.new('Quick Attack', :normal, 40, 100),
		'rage' => Move.new('Rage', :normal, 20, 100),
		'selfdestruct' => Move.new('Selfdestruct', :normal, 200, 100),
		'eggbomb' => Move.new('Egg Bomb', :normal, 100, 75),
		'lick' => Move.new('Lick', :ghost, 20, 100),
		'smog' => Move.new('Smog', :poison, 20, 70),
		'sludge' => Move.new('Smudge', :poison, 65, 100),
		'boneclub' => Move.new('Bone Club', :ground, 65, 85),
		'fireblast' => Move.new('Fire Blast', :fire, 120, 85),
		'waterfall' => Move.new('Waterfall', :water, 80, 100),
		'clamp' => Move.new('Clamp', :water, 35, 85),
		'swift' => Move.new('Swift', :normal, 60, 100),
		'skullbash' => Move.new('Skull Bash', :normal, 100, 100),
		'spikecannon' => Move.new('Spike Cannon', :normal, 20, 100),
		'constrict' => Move.new('Constrict', :normal, 10, 100),
		'hijumpkick' => Move.new('Hi Jump Kick', :fighting, 130, 90),
		'dreameater' => Move.new('Dream Eater', :psychic, 100, 100),
		'barrage' => Move.new('Barrage', :normal, 15, 85),
		'leechlife' => Move.new('Leech Life', :bug, 20, 100),
		'skyattack' => Move.new('Sky Attack', :flying, 140, 90),
		'bubble' => Move.new('Bubble', :water, 20, 100),
		'dizzypunch' => Move.new('Dizzy Punch', :normal, 70, 100),
		'crabhammer' => Move.new('Crabhammer', :water, 90, 90),
		'explosion' => Move.new('Explosion', :normal, 250, 100),
		'furyswipes' => Move.new('Fury Swipes', :normal, 18, 80),
		'bonemerang' => Move.new('Bonemerang', :ground, 50, 90),
		'rockslide' => Move.new('Rock Slide', :rock, 75, 90),
		'hyperfang' => Move.new('Hyper Fang', :normal, 80, 90),
		'triattack' => Move.new('Tri Attack', :normal, 80, 100),
		'slash' => Move.new('Slash', :normal, 70, 100),
		'struggle' => Move.new('Struggle', :normal, 50, 100)
	}

	def Move.show_moves
		$moves.each do |k,v|
			puts v.name
		end
	end
end
