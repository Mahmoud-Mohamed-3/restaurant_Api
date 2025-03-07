class AddBookedAtToTable < ActiveRecord::Migration[8.0]
  def change
    add_column :tables, :booked_from, :datetime
    add_column :tables, :booked_to, :datetime
  end
end
