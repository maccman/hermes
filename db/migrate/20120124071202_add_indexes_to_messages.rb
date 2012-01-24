class AddIndexesToMessages < ActiveRecord::Migration
  def change
    add_index :messages, :uid
    add_index :conversations, :uid
    add_index :users, :uid
  end
end