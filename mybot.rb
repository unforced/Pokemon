require 'cinch'
include 'pokebot.rb'

bot = Cinch::Bot.new do
	configure do |c|
		c.server = ""
		c.channels = []
		c.plugins.plugins = [Cinch::Plugins::Pokebot]
		c.nick = 'botname'
	end
end

bot.start
