class AddReceivedAtToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :received_at, :datetime
  end
end