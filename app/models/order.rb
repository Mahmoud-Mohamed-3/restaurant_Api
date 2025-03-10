class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :user
  has_many :completed_orders, dependent: :destroy

  enum :order_status, { pending: "pending", completed: "completed" }

  def update_total_price_and_status
    self.total_price = order_items.sum { |item| item.price }

    if order_items.exists? && order_items.all? { |item| item.status == "ready" }
      self.order_status = "completed"
      move_to_completed_orders unless completed_orders.exists? # Prevent duplicate completed orders
    else
      self.order_status = "pending"
    end
    save!
  end
  def order_items
    OrderItem.where(order_id: id)
  end
  private

  def move_to_completed_orders
    # Only create a new completed order if none exists already
    CompletedOrder.create!(
      order: self,
      user: user,
      total_price: total_price,
      completed_at: Time.current
    )
  end
end
