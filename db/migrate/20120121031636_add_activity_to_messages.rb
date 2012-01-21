class AddActivityToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :activity, :boolean
  end
end