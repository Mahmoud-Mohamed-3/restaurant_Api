module Api
  module V1
    class ChefsController < ApplicationController
      def show_chefs_for_users
        chefs = Chef.all
        render json: { status: 200, message: "Chefs fetched successfully.", data: chefs.map { |chef| ChefInfoForUserSerializer.new(chef) } }
      end
    end
  end
end
