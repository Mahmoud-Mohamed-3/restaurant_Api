class DropTablesTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :tables
  end
end
