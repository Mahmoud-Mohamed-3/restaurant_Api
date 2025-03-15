class CategoryStatsSerializer < ActiveModel::Serializer
  attributes :title, :total_revenue, :total_foods, :total_ingredients, :total_orders

  def total_revenue
    object.foods.map { |food| food.order_items.sum(:price) }.sum
  end
  def total_foods
    object.foods.count
  end
  def total_ingredients
    object.foods.map { |food| food.ingredients.count }.sum
  end
  def total_orders
    object.foods.map { |food| food.order_items.count }.sum
  end
  # def most_ordered_food
  #   object.foods.max_by { |food| food.order_items.count }
  # end
  # def least_ordered_food
  #   object.foods.min_by { |food| food.order_items.count }
  # end
end
