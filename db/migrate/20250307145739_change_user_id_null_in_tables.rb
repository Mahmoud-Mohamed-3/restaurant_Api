class ChangeUserIdNullInTables < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tables, :user_id, true
  end
end
