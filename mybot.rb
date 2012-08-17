require 'cinch'
load 'pokebot.rb'

bot = Cinch::Bot.new do
	configure do |c|
		c.server = "servername"
		c.channels = ["#channelname"]
		c.plugins.plugins = [Cinch::Plugins::Pokebot]
		c.plugins.prefix = //
		c.nick = 'botbame'
	end
end

bot.start
