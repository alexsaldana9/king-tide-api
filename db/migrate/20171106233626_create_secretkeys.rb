class CreateSecretkeys < ActiveRecord::Migration[5.1]
  def change
    create_table :secretkeys do |t|

      t.timestamps
    end
  end
end
