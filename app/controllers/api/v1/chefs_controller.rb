module Api
  module V1
    class ChefsController < ApplicationController
      before_action :authenticate_chef!, only: [ :get_current_chef ]
      before_action :authenticate_owner!, only: [ :get_category_chef ]
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

      def get_category_chef
        category = Category.find_by(id: params[:id])
        if category.nil?
          render json: { status: 404, message: "Category not found." }, status: :not_found
        else
          chef = category.chef
          render json: { status: 200, message: "Chefs fetched successfully.", data: ChefSerializer.new(chef) }
        end
      end
    end
  end
end
