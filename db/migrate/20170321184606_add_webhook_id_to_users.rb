class AddWebhookIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :webhook_id, :string, limit: 24
    add_index :users, :webhook_id, unique: true
    remove_column :users, :bot
  end
end
