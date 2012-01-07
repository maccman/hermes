class MoveAccessToken < ActiveRecord::Migration
  def up
    add_column :users, :access_token, :string
    remove_column :conversations, :access_token
  end

  def down
  end
end