class AddIndexToTables < ActiveRecord::Migration[8.0]
  def change
    add_index :tables, [ :booked_from, :booked_to ]
  end
end
