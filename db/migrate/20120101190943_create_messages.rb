class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :subject
      t.text :body
      t.string :avatar_url
      t.integer :conversation_id
      t.integer :user_id

      t.timestamps
    end
  end
end
