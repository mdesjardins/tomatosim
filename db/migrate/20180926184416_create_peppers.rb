class CreatePeppers < ActiveRecord::Migration[5.2]
  def change
    rename_table :tomatoes, :plants
    add_column :plants, :type, :string
  end
end
