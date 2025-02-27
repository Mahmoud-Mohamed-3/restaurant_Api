class AddPriceToFood < ActiveRecord::Migration[8.0]
  def change
    add_column :foods, :price, :decimal , precision: 10, scale: 2, default: "0.0"
  end
end
