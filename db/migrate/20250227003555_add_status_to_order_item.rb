class AddStatusToOrderItem < ActiveRecord::Migration[8.0]
  def change
    add_column :order_items, :status, :string
  end
end
