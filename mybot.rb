require 'cinch'
load 'pokebot.rb'

bot = Cinch::Bot.new do
	configure do |c|
		c.server = "irc.swiftirc.net"
		c.channels = ["#limey-llama"]
		c.plugins.plugins = [Cinch::Plugins::Pokebot]
		c.plugins.prefix = //
		c.nick = 'aaronbot'
	end
end

bot.start
