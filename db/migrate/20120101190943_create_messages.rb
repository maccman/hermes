class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :subject
      t.text :body
      t.datetime :sent_at
      t.integer :conversation_id
      t.integer :from_user_id

      t.timestamps
    end
  end
end
