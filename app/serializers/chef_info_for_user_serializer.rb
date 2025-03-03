class ChefInfoForUserSerializer< ActiveModel::Serializer
  attributes  :first_name, :last_name, :age, :category_name, :profile_image_url
  def profile_image_url
    Rails.application.routes.url_helpers.rails_blob_url(object.profile_image, host: "http://localhost:3000")if object.profile_image.attached?
  end
  def category_name
    object.category.title
  end
end