class CreateReadings < ActiveRecord::Migration[5.1]
  def change
    create_table :readings do |t|
      t.float :depth
      t.string :units_depth
      t.integer :salinity
      t.string :units_salinity
      t.text :description

      t.timestamps
    end
  end
end
