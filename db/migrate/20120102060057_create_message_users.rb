class CreateMessageUsers < ActiveRecord::Migration
  def change
    create_table :message_users do |t|
      t.integer :message_id
      t.integer :user_id
      t.timestamps
    end
  end
end
