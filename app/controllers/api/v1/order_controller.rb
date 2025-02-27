module Api
  module V1
    class OrderController < ApplicationController
      before_action :authenticate_user!, only: [ :create_order ]

      def create_order
        order = Order.new(user_id: current_user.id, order_time: Time.now, order_status: "pending")
        if order.save
          render json: { status: 201, message: "Order created successfully.", data: order }, status: :created
        else
          render json: { status: 422, message: "Order creation failed.", errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      # def order_params
      #   params.require(:order).permit(:status, order_items_attributes: [:food_id, :quantity, :chef_id])
      # end

      # def calculate_total_price
      #   total_price = 0
      #   return total_price unless params[:order][:order_items_attributes]
      #
      #   params[:order][:order_items_attributes].each do |order_item|
      #     food = Food.find_by(id: order_item[:food_id])
      #     next unless food
      #
      #     total_price += food.price * order_item[:quantity].to_i
      #   end
      #
      #   total_price
      # end
    end
  end
end
