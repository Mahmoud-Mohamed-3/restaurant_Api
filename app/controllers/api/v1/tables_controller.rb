module Api
  module V1
    class TablesController < ApplicationController
      before_action :authenticate_owner!, only: [ :create ]

      def index
        tables = Table.all
        render json: {
          status: 200,
          message: "Tables retrieved successfully",
          data: tables.map { |table| TableSerializer.new(table).serializable_hash }
        }
      end

      def create
        @table = Table.new(table_params)

        if @table.save
          render json: @table, status: :created
        else
          render json: @table.errors, status: :unprocessable_entity
        end
      end


      private

      def table_params
        params.require(:table).permit(:num_of_seats, :table_name)
      end
    end
  end
end
