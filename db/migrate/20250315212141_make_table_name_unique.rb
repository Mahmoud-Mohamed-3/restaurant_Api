class MakeTableNameUnique < ActiveRecord::Migration[8.0]
  def change
    add_index :tables, :table_name, unique: true
  end
end
