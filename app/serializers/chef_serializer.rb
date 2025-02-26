class ChefSerializer
  include JSONAPI::Serializer
  attributes :email, :first_name, :last_name, :phone_number, :age, :salary, :id
end
