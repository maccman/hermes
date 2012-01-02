class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string  :uid
      t.integer :from_user_id
      t.boolean :read, :default => false
      t.boolean :archived, :default => false
      t.timestamps
    end
  end
end
