module JwtHelper
    def generate_token(user)
      JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base, 'HS256')
    end
end

RSpec.configure do |config|
    config.include JwtHelper
end
