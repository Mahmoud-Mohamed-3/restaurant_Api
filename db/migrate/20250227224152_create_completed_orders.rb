class CreateCompletedOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :completed_orders do |t|
      t.references :order, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price, precision: 10, scale: 2, null: false, default: 0.0
      t.datetime :completed_at, null: false

      t.timestamps
    end
  end
end
