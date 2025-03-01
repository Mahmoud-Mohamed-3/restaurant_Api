class OrderItem < ApplicationRecord
  belongs_to :food
  belongs_to :order
  belongs_to :chef, optional: true

  enum :status, { pending: "pending", preparing: "preparing", ready: "ready" }

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  after_save :update_order_status_and_price
  after_destroy :update_order_status_and_price
  def food_name
    food&.name
    end
    private
    def update_order_status_and_price
      order.update_total_price_and_status
      order.save if order.changed? # Save only if changes are made
    end
  end
