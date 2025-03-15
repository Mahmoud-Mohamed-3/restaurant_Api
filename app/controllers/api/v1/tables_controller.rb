module Api
  module V1
    class TablesController < ApplicationController
      before_action :authenticate_owner!, only: [ :create ]
      before_action :authenticate_owner!, only: [ :show_tables_for_owner, :update_table, :destroy_table ]

      def index
        tables = Table.all
        render json: {
          status: 200,
          message: "Tables retrieved successfully",
          data: tables.map { |table| TableSerializer.new(table).serializable_hash }
        }
      end

      def show_tables_for_owner
        tables = Table.all
        render json: {
          status: 200,
          message: "Tables retrieved successfully",
          data: tables.map { |table| TableForOwnerSerializer.new(table) }
        }
      end

      def update_table
        @table = Table.find(params[:id])
        if @table.update(table_params)
          render json: @table, status: :ok
        else
          render json: @table.errors, status: :unprocessable_entity
        end
      end

      def destroy_table
        @table = Table.find(params[:id])
        if @table.destroy
          render json: { status: 200, message: "Table deleted successfully." }
        else
          render json: { status: 500, message: "Table deletion failed." }, status: :internal_server_error
        end
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
