class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :uid
      t.string :handle
      t.string :twitter_token
      t.string :twitter_secret
      t.string :name
      t.string :avatar_url
      t.text   :description

      t.timestamps
    end
  end
end