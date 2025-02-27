class FoodSerializer
  include JSONAPI::Serializer
  attributes  :name , :description , :price , :category_id ,:id, :ingredients

  private
  def ingredients
    object.ingredients.map do |ingredient|
      {
        id: ingredient.id,
        name: ingredient.name
      }
    end
  end
end
