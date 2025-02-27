module Api
  module V1
    class ChefActionsController < ApplicationController
      before_action :authenticate_chef!

      def create_food
        @category_id = current_chef.category_id
        food = Food.new(food_params.merge(category_id: @category_id))
        if food.save
          render json: { status: 201, message: "Food created successfully.", data: food }, status: :created
        else
          render json: { status: 422, message: "Food creation failed.", errors: food.errors.full_messages }, status: :unprocessable_entity
        end
      end
      def update_food
        food = Food.find_by(id: params[:id])
        @category_id = current_chef.category_id
        if food.nil?
          render json: { status: 404, message: "Food not found." }, status: :not_found
        elsif food.update(food_params.merge(category_id: @category_id))
          render json: { status: 200, message: "Food updated successfully.", data: food }
        else
          render json: { status: 422, message: "Food update failed.", errors: food.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def delete_food
        food = Food.find_by(id: params[:id])
        if food.nil?
          render json: { status: 404, message: "Food not found." }, status: :not_found
        elsif food.destroy
          render json: { status: 200, message: "Food deleted successfully." }
        else
          render json: { status: 500, message: "Food deletion failed." }, status: :internal_server_error
        end
      end
      def add_ingredient
        ingredient = Ingredient.new(ingredient_params)
        if ingredient.save
          render json: { status: 201, message: "Ingredient added successfully.", data: ingredient }, status: :created
        else
          render json: { status: 422, message: "Ingredient addition failed.", errors: ingredient.errors.full_messages }, status: :unprocessable_entity
        end
      end
      def delete_ingredient
        ingredient = Ingredient.find_by(id: params[:id])
        if ingredient.nil?
          render json: { status: 404, message: "Ingredient not found." }, status: :not_found
        elsif ingredient.destroy
          render json: { status: 200, message: "Ingredient deleted successfully." }
        else
          render json: { status: 500, message: "Ingredient deletion failed." }, status: :internal_server_error
        end
      end

      def show_all_orders
        orders = current_chef.order_items
        render json: { status: 200, message: "Assigned orders fetched successfully.", data: OrderItemsSerializer.new(orders) }
      end

      def show_pending_orders
        orders = current_chef.order_items.where(status: "pending")
        render json: { status: 200, message: "Pending orders fetched successfully.", data: orders }
      end

      def update_order_status
        order_item = OrderItem.find_by(id: params[:id])
        if order_item.nil?
          render json: { status: 404, message: "Order not found." }, status: :not_found
        elsif order_item.update(update_order_params)
          render json: { status: 200, message: "Order status updated successfully.", data: order_item }
        else
          render json: { status: 422, message: "Order status update failed.", errors: order_item.errors.full_messages }, status: :unprocessable_entity
        end
      end
      private
      def update_order_params
        params.require(:order_item).permit(:status)
      end
      def food_params
        params.require(:food).permit(:name, :description, :price)
      end
      def ingredient_params
        params.require(:ingredient).permit(:name, :food_id)
      end
    end
  end
end