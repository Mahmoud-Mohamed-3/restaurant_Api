class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :order_time
      t.string :order_status, default: "pending"
      t.decimal :total_price, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
