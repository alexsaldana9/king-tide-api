class AddColumnsToSecretkey < ActiveRecord::Migration[5.1]
  def change
    add_column :secretkeys, :name, :string
    add_column :secretkeys, :key, :string
  end
end
