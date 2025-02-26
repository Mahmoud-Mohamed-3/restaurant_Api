class AddSomeColumnsTo < ActiveRecord::Migration[8.0]
  def change
    add_column :owners, :first_name, :string, null: false
    add_column :owners, :last_name, :string, null: false
    add_column :owners, :phone_number, :string, null: false
  end
end
