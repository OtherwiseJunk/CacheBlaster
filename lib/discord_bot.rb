require 'discordrb'
require 'active_record'

module Discord
  # Get the database configuration from the Rails application
  db_config = Rails.application.config.database_configuration[Rails.env]

# Establish a connection to the database
  ActiveRecord::Base.establish_connection(db_config)
  class Bot
    def initialize
      @bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_BOT_TOKEN'], prefix: "?"
    end

    def start
      setup_listeners
      register_slash_commands
      @bot.run
    end

    private

    def setup_listeners
      @bot.message(content: 'Hey CacheBlaster') do |event|
        event.respond 'Shut up idiot.'
      end
      @bot.application_command :exists_in_db do |event|
        user = User.find_by(id: event.user.id)
        response = user ? "Yes" : "No"
        event.respond(content: response)
      end
    end


    def register_slash_commands
      @bot.register_application_command(:exists_in_db, "Checks if user has registered with us through the site.", server_id: 1219366266033405952)
    end
  end
end
