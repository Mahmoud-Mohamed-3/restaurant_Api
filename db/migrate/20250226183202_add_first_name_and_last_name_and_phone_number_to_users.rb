class AddFirstNameAndLastNameAndPhoneNumberToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string, null: false, default: ""
    add_column :users, :last_name, :string, null: false, default: ""
    add_column :users, :phone_number, :string, null: false, default: ""
  end
end
