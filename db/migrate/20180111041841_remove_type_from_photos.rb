class RemoveTypeFromPhotos < ActiveRecord::Migration[5.1]
  def change
    remove_column :photos, :type, :integer
  end
end
