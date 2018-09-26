class RenameTomatoIdOnTurns < ActiveRecord::Migration[5.2]
  def change
    rename_column :turns, :tomato_id, :plant_id
  end
end
