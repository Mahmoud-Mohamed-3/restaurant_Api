class OrderSerializer
  include JSONAPI::Serializer
  attributes :status, :total_price, :user_id, :id, :order_time
  has_many :order_items
  belongs_to :user
  belongs_to :chef
  private
  def order_items
    object.order_items.map do |order_item|
      {
        id: order_item.id,
        food_id: order_item.food_id,
        order_id: order_item.order_id,
        quantity: order_item.quantity,
        price: order_item.price,
        created_at: order_item.created_at,
        updated_at: order_item.updated_at,
        chef_id: order_item.chef_id,
        status: order_item.status
      }
    end
  end
end
