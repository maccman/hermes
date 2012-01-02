class AddStarredToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :starred, :boolean
  end
end