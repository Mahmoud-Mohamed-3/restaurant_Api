class CategoryForOwnerSerializer < ActiveModel::Serializer
  attributes :id, :title, :num_of_foods, :num_of_ingredients, :chef_name, :image_url, :chef_id
  # has_one :chef
  def num_of_foods
    object.foods.count
  end

  def num_of_ingredients
    object.foods.map { |food| food.ingredients.count }.sum
  end
  def chef_name
    object.chef.first_name + " " + object.chef.last_name
  end
  def chef_id
    object.chef.id
  end
  def image_url
    Rails.application.routes.url_helpers.rails_blob_url(object.image, host: "http://localhost:3000") if object.image.attached?
  end
end
