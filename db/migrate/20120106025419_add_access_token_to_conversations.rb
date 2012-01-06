class AddAccessTokenToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :access_token, :string
  end
end