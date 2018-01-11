class AddCategoryToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :category, :integer
  end
end
