class AddGuildIdsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :guild_ids, :text
  end
end
