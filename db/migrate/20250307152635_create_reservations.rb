class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :table, null: false, foreign_key: true
      t.datetime :booked_from, null: false
      t.datetime :booked_to, null: false
      t.string :status, default: 'pending' # Default status set to 'pending'
      t.timestamps
    end

    # Add an index on the booked_from and booked_to columns for better query performance
    add_index :reservations, [ :booked_from, :booked_to ]
  end
end
