
class RecommendedFoodSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :image_url

  def image_url
    Rails.application.routes.url_helpers.rails_blob_url(object.image, host: "http://localhost:3000") if object.image.attached?
  end
end
