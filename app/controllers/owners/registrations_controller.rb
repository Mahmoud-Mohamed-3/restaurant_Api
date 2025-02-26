# frozen_string_literal: true

class Owners::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json
  private
  def sign_up_params
    params.require(:owner).permit(:email, :password, :first_name, :last_name, :phone_number)
  end
  def respond_with(resource, _opts = {})
    if request.method == "POST" && resource.persisted?
      render json: { message: "Signed up successfully.", data: resource }, status: :ok

    elsif request.method == "DELETE"
      sign_out(resource)
      render json: { message: "Account deleted successfully" }, status: :ok

    else
      render json: { status: { code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" } }, status: :unprocessable_entity
    end
  end
end
