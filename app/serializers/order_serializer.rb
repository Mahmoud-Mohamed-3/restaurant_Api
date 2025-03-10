class OrderSerializer< ActiveModel::Serializer
  attributes :order_status, :total_price, :user_id, :id, :order_time, :order_items
  # belongs_to :user

  # Remove the `has_many :order_items` declaration to avoid auto-serialization
  def order_items
    # Manually serialize the order items
    object.order_items.map do |item|
      {
        id: item.id,
        food_id: item.food_id,
        quantity: item.quantity,
        price: item.price,
        chef_id: item.chef_id,
        status: item.status,
      food_name: item.food.name
      }
    end
  end
end
