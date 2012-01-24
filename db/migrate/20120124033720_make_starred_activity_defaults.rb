class MakeStarredActivityDefaults < ActiveRecord::Migration
  def up
    change_column_default :messages, :starred, false
    change_column_default :messages, :activity, false
  end

  def down
  end
end