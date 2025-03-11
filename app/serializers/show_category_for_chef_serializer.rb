class ShowCategoryForChefSerializer < ActiveModel::Serializer
  attributes :id, :title, :image_url, :created_at, :updated_at, :foods

  def image_url
    # Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) if object.image.attached?
    Rails.application.routes.url_helpers.rails_blob_url(object.image, host: "http://localhost:3000") if object.image.attached?
  end

  def foods
    object.foods.map do |food|
      food_data = {
        id: food.id,
        name: food.name,
        description: food.description,
        price: food.price,
        ingredients: food.ingredients.map do |ingredient|
          {
            id: ingredient.id,
            name: ingredient.name
          }
        end
      }

      # Add image_url only if the image is attached
      if food.image.attached?
        food_data[:image_url] = Rails.application.routes.url_helpers.rails_blob_url(food.image, host: "http://localhost:3000")
      end

      food_data
    end
  end
end
