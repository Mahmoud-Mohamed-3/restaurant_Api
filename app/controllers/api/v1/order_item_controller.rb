module Api
  module V1
    class OrderItemController < ApplicationController
      before_action :authenticate_user!, only: [ :create_order_item ]

      def create_order_item
        order = Order.find_by(id: params[:order_id])
        return render json: { status: 404, message: "Order not found." }, status: :not_found if order.nil?

        food = Food.find_by(id: order_item_params[:food_id])
        return render json: { status: 404, message: "Food not found." }, status: :not_found if food.nil?

        chef = assign_chef(food)
        return render json: { status: 404, message: "No available chef." }, status: :not_found if chef.nil?

        order_item = OrderItem.new(order_item_params.merge(order_id: order.id, price: calculate_price(food), chef_id: chef.id, status: "pending"))

        if order_item.save
          render json: { status: 201, message: "Order item created successfully.", data: order_item }, status: :created
        else
          render json: { status: 422, message: "Order item creation failed.", errors: order_item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def order_item_params
        params.require(:order_item).permit(:food_id, :quantity)
      end

      def calculate_price(food)
        quantity = order_item_params[:quantity].to_i
        food.price * quantity
      end

      def assign_chef(food)
        Chef.find_by(category_id: food.category_id)
      end
    end
  end
end
