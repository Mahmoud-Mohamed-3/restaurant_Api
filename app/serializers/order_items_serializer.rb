class OrderItemsSerializer
  include JSONAPI::Serializer
  attributes :food_id, :order_id, :quantity, :price, :chef_id, :status, :food_name

  attribute :food_name do |object|
    object.food.name if object.food
  end
end
