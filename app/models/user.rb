class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [ :discord ]

  serialize :guild_ids, type: Array, coder: JSON
  serialize :guild_icons, type: Array, coder: JSON
  :profile_picture

  def self.from_omniauth(auth)

    user = where(id: auth.uid).first_or_initialize do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end

    user.profile_picture = auth.info.image

    bot_guilds = fetch_bot_guilds
    guilds = fetch_user_guilds(auth.credentials.token).select { |guild| bot_guilds.include?(guild['id']) }

    user.guild_ids = guilds.map { |guild| guild['id'] }
    user.guild_icons = guilds.map { |guild| guild['icon'] ? "https://cdn.discordapp.com/icons/#{guild['id']}/#{guild['icon']}.png" : '/assets/default_guild.png' }

    user.save

    user
  end

  def self.fetch_user_guilds(user_token)
    response = HTTParty.get("https://discord.com/api/v10/users/@me/guilds", headers: {
      "Authorization" => "Bearer #{user_token}"
    })

    return [] unless response.success?

    JSON.parse(response.body)
  end

  def self.fetch_bot_guilds
    bot_auth = "Bot #{ENV['DISCORD_BOT_TOKEN']}"
    response = HTTParty.get("https://discord.com/api/v10/users/@me/guilds", headers: {
      "Authorization" => bot_auth
    })

    return [] unless response.success?

    # Return an array of guild IDs where the bot is a member
    guilds = JSON.parse(response.body)
    guilds.map { |guild| guild['id'] }
  end
end
