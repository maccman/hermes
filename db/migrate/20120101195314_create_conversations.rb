class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string  :uid
      t.boolean :read, :default => false
      t.timestamps
    end
  end
end
