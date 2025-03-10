module Api
  module V1
    class UserActionsController < ApplicationController
      before_action :authenticate_user!, only: [  :get_order, :get_your_orders, :current_user_info, :user_reservations, :user_stats ]
      def current_user_info
        if current_user
          render json: { status: 200, message: "Current user fetched successfully.", data: UserSerializer.new(current_user) }
        else
          render json: { status: 401, message: "Unauthorized. User not logged in." }, status: :unauthorized
        end
      end



      def get_your_orders
        orders = current_user.orders
        render json: { status: 200, message: "Orders fetched successfully.", data: orders.map { |order| OrderSerializer.new(order) } }
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

      def user_reservations
        @reservations = current_user.reservations
        render json: { status: 200, message: "Reservations fetched successfully.", data: @reservations.map { |reservation| ReservationsSerializer.new(reservation) } }
      end
      def seconds_to_time_format(seconds)
        hours = (seconds / 3600).to_i
        minutes = ((seconds % 3600) / 60).to_i
        seconds = (seconds % 60).to_i
        "#{hours}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
      end

      def seconds_to_time_format(seconds)
        hours = (seconds / 3600).to_i
        minutes = ((seconds % 3600) / 60).to_i
        seconds = (seconds % 60).to_i
        "#{hours}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
      end

      def user_stats
        @reservations = current_user.reservations
        @orders = current_user.orders
        @total_reservations = @reservations.count
        @total_orders = @orders.count
        @total_spent = @orders.sum(:total_price)
        @av_spent = @total_spent / @total_orders
@fav_table = current_user.reservations.joins(:table).group("tables.id").count.max_by { |k, v| v }&.first
        # Get completed orders that match with the orders by order_id
        @completed_orders = current_user.completed_orders
        @total_completed_orders = @completed_orders.count
@number_of_orders = @orders.count
        # Filter completed orders with matching order_id
        matched_completed_orders = @completed_orders.where(order_id: @orders.pluck(:id))

        # Calculate the average order time in seconds
        @av_order_time = matched_completed_orders.map { |order| order.completed_at - order.order.created_at }.sum / @total_completed_orders if @total_completed_orders > 0

        # Find the fastest order in seconds
        @fastest_order = matched_completed_orders.map { |order| order.completed_at - order.order.created_at }.min
        @slowest_order = matched_completed_orders.map { |order| order.completed_at - order.order.created_at }.max

        # Most ordered food - Assuming `order_item` is a related model, you may want to join it or handle accordingly
        @most_ordered_food = @orders.joins(:order_items).group("order_items.food_id").count.max_by { |k, v| v }&.first
        @most_ordered_food  = Food.find(@most_ordered_food) if @most_ordered_food
@count_of_most_ordered_food = @orders.joins(:order_items).where(order_items: { food_id: @most_ordered_food.id }).count
        # Most and least valued orders
        @most_valued_order = @orders.max_by(&:total_price)
        @less_valued_order = @orders.min_by(&:total_price)

        # Convert to time format (HH:MM:SS)
        @av_order_time = seconds_to_time_format(@av_order_time) if @av_order_time
        @fastest_order = seconds_to_time_format(@fastest_order) if @fastest_order
        @slowest_order = seconds_to_time_format(@slowest_order) if @slowest_order

@fav_table = Table.find(@fav_table) if @fav_table
        render json: {
          status: 200,
          message: "User stats fetched successfully.",
          total_reservations: @total_reservations,
          total_orders: @total_orders,
          total_spent: @total_spent,
          av_spent: @av_spent,
          av_order_time: @av_order_time,
          fastest_order: @fastest_order,
          slowest_order: @slowest_order,
          most_ordered_food_count: @count_of_most_ordered_food,
          most_ordered_food: FoodSerializer.new(@most_ordered_food), # Assuming you're returning the name or identifier of the most ordered food
          most_valued_order: OrderSerializer.new(@most_valued_order),
          less_valued_order: OrderSerializer.new(@less_valued_order),
          fav_table: TableSerializer.new(@fav_table),
          number_of_orders: @number_of_orders
        }
      end




      def get_category_food
        category = Category.find_by(id: params[:id])
        category_food = category.foods
        return render json: { status: 404, message: "Category not found." }, status: :not_found if category.nil?

        # render json: { status: 200, message: "Category fetched successfully.", data:category_food.map { |food| FoodSerializer.new(food) } }
        render json: { status: 200, message: "Category fetched successfully.", foods: category_food.map { |food | FoodSerializer.new(food) }, category: CategorySerializer.new(category) }
      end
    end
  end
end
