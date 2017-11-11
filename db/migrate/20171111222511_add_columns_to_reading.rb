class AddColumnsToReading < ActiveRecord::Migration[5.1]
  def change
    add_column :readings, :approved, :boolean
    add_column :readings, :deleted, :boolean
  end
end
