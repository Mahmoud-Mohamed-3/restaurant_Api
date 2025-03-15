class TableForOwnerSerializer < ActiveModel::Serializer
  attributes :id, :table_name, :num_of_seats, :num_of_reservations

  def num_of_reservations
    object.reservations.count
  end
end
