class AddTypeToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :type, :integer
  end
end
