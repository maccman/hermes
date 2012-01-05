class AddGoogleToken < ActiveRecord::Migration
  def up
    add_column :users, :google_token, :string
  end

  def down
  end
end