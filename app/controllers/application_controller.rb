class ApplicationController < ActionController::API
    # Decode and authorize the user
    def authorize_request
      header = request.headers["Authorization"]
      header = header.split(" ").last if header
      begin
        @decoded = JWT.decode(header, Rails.application.secrets.secret_key_base, true, algorithm: "HS256")
        @current_user = User.find(@decoded[0]["user_id"])
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
end
