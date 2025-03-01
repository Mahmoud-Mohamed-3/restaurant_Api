# class Users::RegistrationsController < Devise::RegistrationsController
#   include RackSessionsFix
#   respond_to :json
#   private
#   def sign_up_params
#     params.require(:user).permit(:email, :password, :first_name, :last_name, :phone_number)
#   end
#   def respond_with(resource, _opts = {})
#     if request.method == "POST" && resource.persisted?
#       render json: { message: "Signed up successfully.", data: resource }, status: :ok
#
#     elsif request.method == "DELETE"
#       sign_out(resource)
#       render json: { message: "Account deleted successfully" }, status: :ok
#
#     else
#       render json: { status: { code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" } }, status: :unprocessable_entity
#     end
#   end
# end
class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :phone_number)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :first_name, :last_name, :phone_number)
  end

  def update_resource(resource, params)
    if params[:password].present?
      resource.update_with_password(params)
    else
      resource.update(params.except(:current_password))
    end
  end

  def respond_with(resource, _opts = {})
    case request.method
    when "POST"
      if resource.persisted?
        render json: { message: "Signed up successfully.", data: resource }, status: :ok
      else
        render json: { status: { code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" } }, status: :unprocessable_entity
      end

    when "PUT", "PATCH"
      if resource.errors.empty?
        render json: { message: "Account updated successfully.", data: resource }, status: :ok
      else
        render json: { status: { code: 422, message: "Account couldn't be updated. #{resource.errors.full_messages.to_sentence}" } }, status: :unprocessable_entity
      end

    when "DELETE"
      sign_out(resource)
      render json: { message: "Account deleted successfully" }, status: :ok
    end
  end
end

