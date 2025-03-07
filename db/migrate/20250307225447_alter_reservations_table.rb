class AlterReservationsTable < ActiveRecord::Migration[8.0]
  def change
    add_column :reservations, :table_name, :string
    remove_column :reservations, :status
  end
end
