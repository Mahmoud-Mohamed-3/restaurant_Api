class TableSerializer < ActiveModel::Serializer
  attributes :id, :table_name, :num_of_seats
end
