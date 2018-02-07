class RemoveDeletedFromReadings < ActiveRecord::Migration[5.1]
  def change
    remove_column :readings, :deleted, :boolean
  end
end
