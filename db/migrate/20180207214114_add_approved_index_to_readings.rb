class AddApprovedIndexToReadings < ActiveRecord::Migration[5.1]
  def change
    add_index :readings, :approved
  end
end
