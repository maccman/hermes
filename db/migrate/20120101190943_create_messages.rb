class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :subject
      t.text :body
      t.string :avatar_url

      t.timestamps
    end
  end
end
