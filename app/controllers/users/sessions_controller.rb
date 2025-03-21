class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  private

  # Handle successful login response
  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        code: 200,
        message: "Logged in successfully.",
        data: { user: UserSerializer.new(current_user) }
      }
    }, status: :ok
  end

  # Handle logout response
  def respond_to_on_destroy
    current_user = find_user_from_token

    if current_user
      render json: { status: 200, message: "Logged out successfully." }, status: :ok
    else
      render json: { status: 401, message: "Couldn't find an active session." }, status: :unauthorized
    end
  end

  # Extracts user from JWT token
  def find_user_from_token
    return unless request.headers["Authorization"].present?

    token = request.headers["Authorization"].split(" ").last
    begin
      jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
      User.find_by(id: jwt_payload["sub"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end
  def sign_in_params
    params.require(:user).permit(:login, :password)
  end
end
