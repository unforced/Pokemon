require 'cinch'
include 'pokebot.rb'

bot = Cinch::Bot.new do
	configure do |c|
		c.server = ""
		c.channels = []
		c.plugins.plugins = [Pokebot]
		c.nick = 'botname'
	end
end

bot.start
