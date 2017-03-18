class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :uid,      null: false
      t.string :provider, null: false
      t.string :name,     null: false

      t.string :oauth_token
      t.string :oauth_secret

      t.boolean :bot, null: false, default: false

      t.timestamps
    end

    add_index :users, [:provider, :uid], unique: true
    add_index :users, :provider, where: 'bot'
  end
end
