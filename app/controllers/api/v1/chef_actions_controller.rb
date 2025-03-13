module Api
  module V1
    class ChefActionsController < ApplicationController
      before_action :authenticate_chef!
      def create_food
        @category_id = current_chef.category_id
        @food = Food.new(food_params.except(:ingredients).merge(category_id: @category_id))

        if @food.save
          ingredients = params[:food][:ingredients]
          if ingredients.is_a?(Array) && ingredients.present?
            ingredients.each do |ingredient_name|
              @food.ingredients.create!(name: ingredient_name.strip)
            end
          end

          render json: { status: 201, message: "Food created successfully.", data: @food }, status: :created
        else
          render json: { status: 422, message: "Food creation failed.", errors: @food.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update_food
        food = Food.find_by(id: params[:id])

        return render json: { status: 404, message: "Food not found." }, status: :not_found if food.nil?
        food.update(food_params.except(:ingredients))

        food.ingredients.destroy_all

        ingredients = params[:food][:ingredients]
        if ingredients.is_a?(Array) && ingredients.present?
          ingredients.each do |ingredient_name|
            food.ingredients.create!(name: ingredient_name.strip)
          end
        else
          food.ingredients.create!(name: ingredients.strip) if ingredients.present?
        end

        render json: { status: 200, message: "Food updated successfully.", data: food }
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


      def get_your_category
        cat_id = current_chef.category_id
        @category = Category.find_by(id: cat_id)
        if @category.nil?
          render json: { status: 404, message: "Category not found." }, status: :not_found
        else
          render json: { status: 200, message: "Category fetched successfully.", data: ShowCategoryForChefSerializer.new(@category) }
        end
      end
      def show_all_orders
        # Paginate orders with 10 items per page
        orders = current_chef.order_items.page(params[:page]).per(10)
        total_count = current_chef.order_items.count

        render json: {
          status: 200,
          message: "Assigned orders fetched successfully.",
          data: OrderItemsSerializer.new(orders),
          pagination: {
            current_page: orders.current_page,
            total_pages: orders.total_pages,
            total_count: total_count
          }
        }
      end

      def show_pending_orders
        orders = current_chef.order_items.where(status: "pending")
        render json: { status: 200, message: "Pending orders fetched successfully.", data: orders }
      end

      def update_order_status
        order_item = OrderItem.find_by(id: params[:id])

        if order_item.nil?
          return render json: { status: 404, message: "Order item not found." }, status: :not_found
        end

        if order_item.update(update_order_params)
          order_item.order.update_total_price_and_status # Ensure this method is called on the order
          order_item.order.save if order_item.order.changed?

          render json: { status: 200, message: "Order item updated successfully." }, status: :ok
        else
          render json: { status: 422, message: "Failed to update order item.", errors: order_item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private
      def update_order_params
        params.require(:order_item).permit(:status)
      end
      def food_params
        params.require(:food).permit(:name, :description, :price, :image, ingredients: [])
      end

      def ingredient_params
        params.require(:ingredient).permit(:name, :food_id)
      end
    end
  end
end
