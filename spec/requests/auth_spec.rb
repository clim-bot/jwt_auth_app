require 'rails_helper'
require 'jwt'

RSpec.describe 'Authentication', type: :request do
  let!(:user) { User.create(email: 'test@example.com', password: 'password', password_confirmation: 'password') }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe 'POST /login' do
    context 'with valid credentials' do
      it 'returns a JWT token' do
        post '/login', params: { email: user.email, password: 'password' }, headers: headers
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('token')

        # Decode the token
        decoded_token = JWT.decode(json_response['token'], Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
        expect(decoded_token[0]['user_id']).to eq(user.id)
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized status' do
        post '/login', params: { email: user.email, password: 'wrong_password' }, headers: headers
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Invalid email or password')
      end
    end
  end

  describe 'GET /profile' do
    let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base, 'HS256') }
    let(:auth_headers) { { 'Authorization' => "Bearer #{token}" } }

    context 'with valid token' do
      it 'returns the user profile' do
        get '/profile', headers: auth_headers
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['user']['email']).to eq(user.email)
      end
    end

    context 'with invalid token' do
      it 'returns unauthorized status' do
        get '/profile'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
