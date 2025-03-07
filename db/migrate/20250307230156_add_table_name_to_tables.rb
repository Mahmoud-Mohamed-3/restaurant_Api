class AddTableNameToTables < ActiveRecord::Migration[8.0]
  def change
    add_column :tables, :table_name, :string
  end
end
