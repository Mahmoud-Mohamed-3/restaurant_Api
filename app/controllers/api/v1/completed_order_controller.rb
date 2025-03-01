module Api
  module V1
    class CompletedOrderController < ApplicationController
      before_action :authenticate_user!, only: [ :get_user_completed_orders, :complete_order ]
      before_action :authenticate_owner! , only: [ :get_all_completed_orders ]
      def get_all_completed_orders
        orders = CompletedOrder.all
        render json: { status: 200, message: "Completed orders fetched successfully.", data: CompletedOrdersSerializer.new(orders.map  { |order| order } ) }
      end
      def get_user_completed_orders
        orders = current_user.orders.where(order_status: "completed")
        render json: { status: 200, message: "Completed orders fetched successfully.", data: CompletedOrdersSerializer.new(orders.map  { |order| order } ) }
      end
      def complete_order
        order = Order.find_by(id: params[:order_id])
        return render json: { status: 404, message: "Order not found." }, status: :not_found if order.nil?
        order.update(status: "completed")
        render json: { status: 200, message: "Order completed successfully.", data: CompletedOrdersSerializer.new(order) }
      end
    end
  end
  end