require 'cinch'
load 'pokebot.rb'
load 'twssbot.rb'

bot = Cinch::Bot.new do
	configure do |c|
		c.server = "bis12.com"
		c.channels = ["#lobby"]
		c.plugins.plugins = [Cinch::Plugins::Pokebot, Cinch::Plugins::Twss]
		c.plugins.prefix = //
		c.nick = 'pokebot'
	end
end

bot.start
