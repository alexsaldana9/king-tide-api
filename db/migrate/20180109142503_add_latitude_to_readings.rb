class AddLatitudeToReadings < ActiveRecord::Migration[5.1]
  def change
    add_column :readings, :latitude, :float
  end
end
