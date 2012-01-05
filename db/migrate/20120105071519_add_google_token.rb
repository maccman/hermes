class AddGoogleToken < ActiveRecord::Migration
  def up
    add_column :users, :google_token, :string
    add_column :users, :google_secret, :string
  end

  def down
  end
end