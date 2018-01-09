class AddLongitudeToReadings < ActiveRecord::Migration[5.1]
  def change
    add_column :readings, :longitude, :float
  end
end
