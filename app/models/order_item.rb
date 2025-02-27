class OrderItem < ApplicationRecord
  belongs_to :food
  belongs_to :order
  belongs_to :chef, optional: true

  enum :status, { pending: "pending", preparing: "preparing", ready: "ready" }

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  def food_name
    food&.name
  end
end
