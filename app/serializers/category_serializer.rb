class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :image_url, :description

  def image_url
    # Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) if object.image.attached?
    Rails.application.routes.url_helpers.rails_blob_url(object.image, host: "http://localhost:3000") if object.image.attached?
  end
end
