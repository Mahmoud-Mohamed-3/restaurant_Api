# frozen_string_literal: true

class Chefs::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  private

  def sign_up_params
    params.require(:chef).permit(:email, :password, :first_name, :last_name, :phone_number, :age, :salary)
  end

  def respond_with(resource, _opts = {})
    if request.method == "POST"
      render json: { message: "Creating new chefs is not allowed." }, status: :forbidden
    elsif request.method == "DELETE"
      sign_out(resource)
      render json: { message: "Account deleted successfully" }, status: :ok
    else
      render json: { status: { code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" } }, status: :unprocessable_entity
    end
  end
end
