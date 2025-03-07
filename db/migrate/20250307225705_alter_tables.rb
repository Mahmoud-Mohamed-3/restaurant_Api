class AlterTables < ActiveRecord::Migration[8.0]
  def change
    remove_column :tables, :user_id
    remove_column :tables, :booked_from
    remove_column :tables, :booked_to
    remove_column :tables, :free_at
  end
end
