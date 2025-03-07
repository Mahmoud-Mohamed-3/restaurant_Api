# app/controllers/api/v1/reservations_controller.rb

module Api
  module V1
    class ReservationsController < ApplicationController
      before_action :authenticate_user!, only: [ :create ]
      before_action :authenticate_owner!, only: [ :index ]

      # List all reservations (optional)
      def index
        @reservations = Reservation.all
        render json: { status: 200, message: "Reservations retrieved successfully", data: @reservations.each { |reservation| ReservationsSerializer.new(reservation) } }
      end

      # Create a new reservation
      def create
        @table = Table.find(params[:id]) # Find the table being reserved
        @reservation = Reservation.new(reservation_params.merge(table_id: @table.id, user_id: current_user.id)) # Merge the table_id and user_id

        # Check availability before saving
        if Reservation.check_availability(@reservation.booked_from, @reservation.booked_to, @table.id)
          if @reservation.save
            render json: @reservation, status: :created
          else
            render json: @reservation.errors, status: :unprocessable_entity
          end
        else
          render json: { status: 422, message: "This table is already reserved during the selected time slot." }, status: :unprocessable_entity
        end
      end

      private

      # Strong parameters for reservation creation
      def reservation_params
        params.require(:reservation).permit(:booked_from, :booked_to)
      end
    end
  end
end
