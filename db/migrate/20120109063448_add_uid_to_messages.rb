class AddUidToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :uid, :string
  end
end