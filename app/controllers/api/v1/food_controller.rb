module Api
  module V1
    class FoodController < ApplicationController
      def show_food
        food = Food.find_by(id: params[:id])
        if food.nil?
          render json: { status: 404, message: "Food not found." }, status: :not_found
        else
          render json: { status: 200, message: "Food fetched successfully.", data: FoodSerializer.new(food) }
        end
      end
      def search_food
        query = params[:query]
        if query
          @food = Food.search(
            query: {
              wildcard: {
                "name.lower": {
                  value: "*#{query.downcase}*"  # Matches any name containing the query letters
                }
              }
            },
            size: 4
          ).records.to_a
        end
        render json: { status: 200, message: "Food fetched successfully.", data: @food.map { |food| FoodForSearchSerializer.new(food) } }
      end




      def recommended_items
        @recommended = Food.all.sample(5)
        render json: { status: 200, message: "Recommended items fetched successfully.", data: @recommended.map { |food| RecommendedFoodSerializer.new(food) } }
      end
    end
  end
end
