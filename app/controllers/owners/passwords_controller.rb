# frozen_string_literal: true

class Owner::PasswordsController < Devise::PasswordsController
  include RackSessionsFix

  private
  def edit_password_params
    params.require(:owner).permit(:password, :password_confirmation, :current_password)
  end
  def respond_with(resource, _opts = {})
    if request.method == "PUT" && resource.errors.empty?
      render json: { message: "Password updated successfully.", data: resource }, status: :ok
    else
      render json: { status: { code: 422, message: "Password couldn't be updated successfully. #{resource.errors.full_messages.to_sentence}" } }, status: :unprocessable_entity
    end
  end
end
