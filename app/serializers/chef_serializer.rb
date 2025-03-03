class ChefSerializer < ActiveModel::Serializer
  attributes :email, :first_name, :last_name, :phone_number, :age, :salary, :id, :category_id, :profile_image_url

  def profile_image_url
    Rails.application.routes.url_helpers.rails_blob_url(object.profile_image, host: "http://localhost:3000") if object.profile_image.attached?
  end
end
