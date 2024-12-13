class AddGuildIconsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :guild_icons, :string
  end
end
