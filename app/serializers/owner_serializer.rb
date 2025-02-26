class OwnerSerializer
  include JSONAPI::Serializer
  attributes :email, :first_name, :last_name, :phone_number, :id
end
