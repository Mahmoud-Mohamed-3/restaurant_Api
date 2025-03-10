class ReservationsSerializer < ActiveModel::Serializer
  attributes :id, :booked_from, :booked_to, :table_name, :num_of_seats

  def table_name
    object.table_name
  end
  def num_of_seats
    object.num_of_seats
  end
end
