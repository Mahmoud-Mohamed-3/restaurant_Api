module Api
  module V1
    class UserActionsController < ApplicationController
      before_action :authenticate_user! , only: [  :get_order ]

      def get_your_orders
        orders = current_user.orders
        render json: { status: 200, message: "Orders fetched successfully.", data: OrderSerializer.new(orders) }
      end
      def get_order
        order = Order.find_by(id: params[:id])
        return render json: { status: 404, message: "Order not found." }, status: :not_found if order.nil?

        order.update_total_price_and_status
        order.save if order.changed? # Save only if changes are detected

        render json: { status: 200, message: "Order fetched successfully.", data: OrderSerializer.new(order) }
      end

      def get_categories
        categories = Category.all
        render json: categories, each_serializer: CategorySerializer, status: 200, message: "Categories fetched successfully."
      end





      def get_category_food
        category = Category.find_by(id: params[:id])
        category_food = category.foods
        return render json: { status: 404, message: "Category not found." }, status: :not_found if category.nil?

        render json: { status: 200, message: "Category fetched successfully.", data:category_food.map { |food| FoodSerializer.new(food) } }

      end
    end
  end
end