class FoodSerializer < ActiveModel::Serializer

  attributes :name, :description, :price, :category_id, :id, :ingredients, :category_name, :image_url

  def image_url
    Rails.application.routes.url_helpers.rails_blob_url(object.image, host: "http://localhost:3000")if object.image.attached?
  end
  private
  def ingredients
    object.ingredients.map do |ingredient|
      {
        id: ingredient.id,
        name: ingredient.name
      }
    end
  end
  def category_name
    object.category.title
  end
end
