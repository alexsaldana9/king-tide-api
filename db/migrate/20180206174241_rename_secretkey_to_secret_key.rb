class RenameSecretkeyToSecretKey < ActiveRecord::Migration[5.1]
  def change
    rename_table :secretkeys, :secret_keys
  end
end
