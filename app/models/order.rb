class Order < ApplicationRecord
  has_many :order_items
  belongs_to :user

  after_create :assign_chefs_to_order_items
  enum :order_status, { pending: "pending", completed: "completed" }
  private

  def assign_chefs_to_order_items
    total_price = order_items.sum(&:price)
    update(total_price: total_price)
  end
end
