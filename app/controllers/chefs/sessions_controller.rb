# frozen_string_literal: true

class Chefs::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  private

  # Handle successful login response
  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        code: 200,
        message: "Logged in successfully.",
        data: { chef: ChefSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }
    }, status: :ok
  end

  # Handle logout response
  def respond_to_on_destroy
    current_user = find_chef_from_token

    if current_user
      render json: { status: 200, message: "Logged out successfully." }, status: :ok
    else
      render json: { status: 401, message: "Couldn't find an active session." }, status: :unauthorized
    end
  end

  # Extracts Chef from JWT token
  def find_chef_from_token
    return unless request.headers["Authorization"].present?

    token = request.headers["Authorization"].split(" ").last
    begin
      jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
      Chef.find_by(id: jwt_payload["sub"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end

  # Allow authentication with email or phone number
  def sign_in_params
    params.require(:chef).permit(:login, :password)
  end
end
