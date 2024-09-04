require_relative '../discord_bot'

namespace :discord do
  desc 'Start the Discord bot'
  task run: :environment do
    Discord::Bot.new.start
  end
end
