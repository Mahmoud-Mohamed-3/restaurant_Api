class CompletedOrdersSerializer
  include JSONAPI::Serializer
  attributes  :completed_at, :total_price, :order_id, :user_name

  attribute :user_name do |object|
    object.user.first_name if object.user
  end
end
