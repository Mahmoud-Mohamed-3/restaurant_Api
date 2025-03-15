module Api
  module V1
    class OwnerStatsController < ApplicationController
      before_action :authenticate_owner!
      def overall_stats
        @total_orders = Order.count
        @total_revenue = Order.sum(:total_price)
        @total_customers = User.count
        @total_chefs = Chef.count
        @total_categories = Category.count
        @total_tables = Table.count
        @total_reservations = Reservation.count
        @total_foods = Food.count
        @total_ingredients = Ingredient.count
        @total_completed_orders = CompletedOrder.count

        render json: {
          total_orders: @total_orders,
          total_revenue: @total_revenue,
          total_customers: @total_customers,
          total_chefs: @total_chefs,
          total_categories: @total_categories,
          total_tables: @total_tables,
          total_reservations: @total_reservations,
          total_foods: @total_foods,
          total_ingredients: @total_ingredients,
          total_completed_orders: @total_completed_orders
        }, status: :ok
      end

      def category_stats
        @categories = Category.includes(foods: :order_items)

        # Find the most ordered food globally using SQL aggregation
        @most_ordered_food = Food.joins(:order_items)
                                 .group("foods.id")
                                 .order("COUNT(order_items.id) DESC")
                                 .limit(1)
                                 .first

        @category_stats = @categories.map do |category|
          foods = category.foods.includes(:order_items)

          {
            category: CategoryStatsSerializer.new(category),
            most_ordered_food: foods.max_by { |food| food.order_items.size },
            least_ordered_food: foods.min_by { |food| food.order_items.size },
            most_valued_food: foods.max_by { |food| food.order_items.sum(&:price) },
            least_valued_food: foods.min_by { |food| food.order_items.sum(&:price) },
            average_price_per_order: foods.sum { |food| food.order_items.sum(&:price) } / (foods.sum { |food| food.order_items.count }.nonzero? || 1),
            total_orders: foods.sum { |food| food.order_items.count }
          }
        end

        render json: {
          status: 200,
          message: "Category stats fetched successfully.",
          data: {
            category_stats: @category_stats,
            most_ordered_food: FoodSerializer.new(@most_ordered_food)
          }
        }, status: :ok
      end

      def user_stats
        @users = User.includes(orders: :order_items, reservations: {}, completed_orders: {})

        @user_stats = @users.map do |user|
          orders = user.orders
          reservations = user.reservations
          completed_orders = user.completed_orders

          total_orders = orders.count
          total_spent = orders.sum(:total_price)
          average_spent = total_orders.positive? ? (total_spent / total_orders) : 0

          {
            user: UserSerializer.new(user),
            total_orders: total_orders,
            total_reservations: reservations.count,
            total_spent: total_spent,
            average_spent: average_spent,
            most_ordered_food: most_ordered_food(user),
            most_valued_order: orders.order(total_price: :desc).first,
            least_valued_order: orders.order(total_price: :asc).first
          }
        end

        render json: {
          status: 200,
          message: "User stats fetched successfully.",
          data: @user_stats
        }, status: :ok
      end

      def reservations_stats
        @reservations = Reservation.all
        @total_reservations = @reservations.count
        @total_reservations_today = @reservations.where("created_at >= ?", Time.zone.now.beginning_of_day).count
        @total_reservations_this_month = @reservations.where("created_at >= ?", Time.zone.now.beginning_of_month).count
        @total_reservations_this_year = @reservations.where("created_at >= ?", Time.zone.now.beginning_of_year).count
        @total_reservations_this_week = @reservations.where("created_at >= ?", Time.zone.now.beginning_of_week).count
        @total_reservations_last_30_days = @reservations.where("created_at >= ?", 30.days.ago).count
        @total_reservations_last_7_days = @reservations.where("created_at >= ?", 7.days.ago).count
        @upcoming_reservations = @reservations.where("booked_from >= ?", Time.zone.now).map { |reservation| ReservationsSerializer.new(reservation) }
        @total_upcoming_reservations = @upcoming_reservations.count
        @past_reservations = @reservations.where("booked_from < ?", Time.zone.now).map { |reservation| ReservationsSerializer.new(reservation) }
        @total_past_reservations = @past_reservations.count

        # Finding most and least booked tables
        most_booked_table_id = @reservations.group(:table_id).order("count_all DESC").limit(1).count.keys.first
        least_booked_table_id = @reservations.group(:table_id).order("count_all ASC").limit(1).count.keys.first
        @most_booked_table = Table.find_by(id: most_booked_table_id)
        @least_booked_table = Table.find_by(id: least_booked_table_id)

        @average_reservation_time = @reservations.sum { |reservation| reservation.booked_to - reservation.booked_from } / @total_reservations
        @average_reservation_time = format_time(@average_reservation_time)

        # Get the count of reservations per user and the user data
        @user_reservation_count = @reservations
                                    .group(:user_id)
                                    .count
        # Get user details
        @user_details = @user_reservation_count.map do |user_id, reservation_count|
          user = User.find(user_id)
          {
            user_name: user.first_name + " " + user.last_name,
            reservation_count: reservation_count
          }
        end

        @reservations = @reservations.map { |reservation| ReservationsSerializer.new(reservation) }

        render json: {
          reservations: @reservations,
          total_reservations: @total_reservations,
          total_reservations_today: @total_reservations_today,
          total_reservations_this_month: @total_reservations_this_month,
          total_reservations_this_year: @total_reservations_this_year,
          total_reservations_this_week: @total_reservations_this_week,
          total_reservations_last_30_days: @total_reservations_last_30_days,
          total_reservations_last_7_days: @total_reservations_last_7_days,
          upcoming_reservations: @upcoming_reservations,
          past_reservations: @past_reservations,
          total_upcoming_reservations: @total_upcoming_reservations,
          total_past_reservations: @total_past_reservations,
          most_booked_table: @most_booked_table,
          least_booked_table: @least_booked_table,
          average_reservation_time: @average_reservation_time,
          user_details: @user_details
        }, status: :ok
      end


      def format_time(seconds)
        hours = (seconds / 3600).to_i
        minutes = ((seconds % 3600) / 60).to_i
        seconds = (seconds % 60).to_i
        "#{hours}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
      end






      private

      def most_ordered_food(user)
        food_id = user.orders.joins(:order_items)
                      .group("order_items.food_id")
                      .order(Arel.sql("COUNT(order_items.food_id) DESC"))
                      .limit(1)
                      .pluck(:food_id)
                      .first
        Food.find_by(id: food_id)
      end
    end
  end
end
