class ReservationsSerializer < ActiveModel::Serializer
  attributes :id, :booked_from, :booked_to, :table_name, :num_of_seats, :user_name, :phone_number

  def table_name
    object.table_name
  end
  def num_of_seats
    object.num_of_seats
  end
  def user_name
    object.user.first_name + " " + object.user.last_name
  end
  def phone_number
    object.user.phone_number
  end
end
