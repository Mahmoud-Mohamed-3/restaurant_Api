module Api
  module V1
    class OwnerPermissionsController < ApplicationController
      before_action :authenticate_owner!
      def create_category
        @category = Category.new(category_params)
        if @category.save
          render json: {
            status: 201,
            message: "Category created successfully.",
            data: @category
          }
        else
          render json: { status: 400, message: "Error creating category", errors: @category.errors.full_messages }, status: :bad_request
        end
      end

      def update_category
        category = Category.find_by(id: params[:id])
        if category.nil?
          render json: { status: 404, message: "Category not found." }, status: :not_found
        elsif category.update(category_params)
          render json: { status: 200, message: "Category updated successfully.", data: category }
        else
          render json: { status: 422, message: "Category update failed.", errors: category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def delete_category
        category = Category.find_by(id: params[:id])
        if category.nil?
          render json: { status: 404, message: "Category not found." }, status: :not_found
        elsif category.destroy
          render json: { status: 200, message: "Category deleted successfully." }
        else
          render json: { status: 500, message: "Category deletion failed." }, status: :internal_server_error
        end
      end

      def get_category
        category = Category.find_by(id: params[:id])
        if category.nil?
          render json: { status: 404, message: "Category not found." }, status: :not_found
        else
          render json: { status: 200, message: "Category fetched successfully.", data: CategorySerializer.new(category) }
        end
      end



      def add_chef
        @chef = Chef.new(chef_params)
        if @chef.save
          render json: { status: 201, message: "Chef created successfully.", data: @chef }, status: :created
        else
          render json: { status: 422, message: "Chef creation failed.", errors: @chef.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update_chef
        category = Category.find_by(id: params[:id])
        chef = category.chef
        # chef = Chef.find_by(id: params[:id])
        if chef.nil?
          render json: { status: 404, message: "Chef not found." }, status: :not_found
        elsif chef.update(chef_params)
          render json: { status: 200, message: "Chef updated successfully.", data: chef }
        else
          render json: { status: 422, message: "Chef update failed.", errors: chef.errors.full_messages }, status: :unprocessable_entity
        end
      end
      def delete_chef
        chef = Chef.find_by(id: params[:id])
        if chef.nil?
          render json: { status: 404, message: "Chef not found." }, status: :not_found
        elsif chef.destroy
          render json: { status: 200, message: "Chef deleted successfully." }
        else
          render json: { status: 500, message: "Chef deletion failed." }, status: :internal_server_error
        end
      end

      def show_all_chefs
        chefs = Chef.all
        render json: { status: 200, message: "All chefs fetched successfully.", data: chefs.map { |chef| ChefSerializer.new(chef) } }
      end

      def show_all_categories
        categories = Category.all
        render json: { status: 200, message: "All categories fetched successfully.", data: categories.map { |category| CategoryForOwnerSerializer.new(category) } }
      end
      private

      def category_params
        params.require(:category).permit(:title, :image, :description)
      end

      def chef_params
        params.require(:chef).permit(:email, :password, :first_name, :last_name, :phone_number, :age, :salary, :category_id, :profile_image)
      end
    end
  end
end
