class CreateTables < ActiveRecord::Migration[8.0]
  def change
    create_table :tables do |t|
      t.integer :num_of_seats, null: false
      t.bigint :user_id, null: true, index: true # Allow user_id to be NULL initially
      t.datetime :booked_from
      t.datetime :booked_to
      t.datetime :free_at

      t.timestamps
    end

    # Add foreign key constraint, allowing NULL values initially
    add_foreign_key :tables, :users, on_delete: :cascade
  end
end
