class AddDeletedAtToReadings < ActiveRecord::Migration[5.1]
  def change
    add_column :readings, :deleted_at, :datetime
    add_index :readings, :deleted_at
  end
end
