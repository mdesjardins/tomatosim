class CreateTurns < ActiveRecord::Migration[5.2]
  def change
    create_table :turns do |t|
      t.belongs_to :tomato
      t.float :nitrogen, default: 0
      t.float :phosphorus, default: 0
      t.float :potassium, default: 0
      t.float :water, default: 0
      t.float :accum_nitrogen, default: 0
      t.float :accum_phosphorus, default: 0
      t.float :accum_potassium, default: 0
      t.float :accum_water, default: 0
      t.float :light, default: 0
      t.timestamps
    end
  end
end
