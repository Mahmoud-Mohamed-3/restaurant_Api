class RemoveTableNameFromReservations < ActiveRecord::Migration[8.0]
  def change
    remove_column :reservations, :table_name, :string
  end
end
