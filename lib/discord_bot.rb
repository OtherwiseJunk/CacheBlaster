require 'discordrb'

module Discord
  class Bot
    def initialize
      @bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']
    end

    def start
      setup_listeners
      @bot.run
    end

    private

    def setup_listeners
      @bot.message(content: 'Hey CacheBlaster') do |event|
        event.respond 'Shut up idiot.'
      end

    end
  end
end
