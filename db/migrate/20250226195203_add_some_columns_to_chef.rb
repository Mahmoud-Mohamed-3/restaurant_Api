class AddSomeColumnsToChef < ActiveRecord::Migration[8.0]
  def change
    add_column :chefs, :first_name, :string, null: false
    add_column :chefs, :last_name, :string, null: false
    add_column :chefs, :phone_number, :string, null: false
    add_column :chefs, :age, :integer, null: false
    add_column :chefs, :salary, :integer, null: false
  end
end
