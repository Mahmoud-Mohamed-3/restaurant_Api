class OrderSerializer
  include JSONAPI::Serializer

  attributes :order_status, :total_price, :user_id, :id, :order_time
  belongs_to :user

  # Remove the `has_many :order_items` declaration to avoid auto-serialization
  attribute :order_items do |object|
    object.order_items.map do |order_item|
      {
        id: order_item.id,
        food_id: order_item.food_id,
        order_id: order_item.order_id,
        quantity: order_item.quantity,
        price: order_item.price,
        status: order_item.status
      }
    end
  end
end
