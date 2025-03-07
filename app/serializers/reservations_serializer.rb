class ReservationsSerializer < ActiveModel::Serializer
  attributes :id, :booked_from, :booked_to, :user_id, :table_id, :table_name

  def table_name
    object.table_name
  end
end
