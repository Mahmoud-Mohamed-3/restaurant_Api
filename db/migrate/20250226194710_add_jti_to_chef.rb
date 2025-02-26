class AddJtiToChef < ActiveRecord::Migration[8.0]
    def change
      add_column :chefs, :jti, :string
      add_index :chefs, :jti
    end
end
