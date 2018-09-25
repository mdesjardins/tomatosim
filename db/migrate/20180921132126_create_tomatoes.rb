class CreateTomatoes < ActiveRecord::Migration[5.2]
  def change
    create_table :tomatoes do |t|
      t.string :name
      t.float :height, null: false, default: 0.0
      t.float :depth, null: false, default: 0.0
      t.float :plant_health, null: false, default: 100.0
      t.float :root_health, null: false, default: 100.0
      t.timestamps
    end
  end
end
