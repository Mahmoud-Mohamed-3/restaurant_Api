module Api
  module V1
    class ChefsController < ApplicationController
      before_action :authenticate_chef!, only: [ :get_current_chef ]
      def get_current_chef
        if current_chef
          render json: { status: 200, message: "Current chef fetched successfully.", data: ChefSerializer.new(current_chef) }
        else
          render json: { status: 401, message: "Unauthorized. Chef not logged in." }, status: :unauthorized
        end
      end
      def show_chefs_for_users
        chefs = Chef.all
        render json: { status: 200, message: "Chefs fetched successfully.", data: chefs.map { |chef| ChefInfoForUserSerializer.new(chef) } }
      end
    end
  end
end
