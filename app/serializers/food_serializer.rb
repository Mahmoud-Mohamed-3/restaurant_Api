class FoodSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :price, :category_id, :id, :ingredients, :category_name

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
