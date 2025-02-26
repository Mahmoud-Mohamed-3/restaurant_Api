class AddJtiToOwner < ActiveRecord::Migration[8.0]
  def change
    add_column :owners, :jti, :string
    add_index :owners, :jti, unique: true
  end
end
