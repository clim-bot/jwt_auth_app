require 'rails_helper'

RSpec.describe 'User Registration', type: :request do
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe 'POST /register' do
    context 'when request is valid' do
      let(:valid_attributes) do
        { user: { email: 'newuser@example.com', password: 'password', password_confirmation: 'password' } }
      end

      it 'creates a new user' do
        post '/register', params: valid_attributes.to_json, headers: headers

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('User created successfully')
        expect(json_response['user']['email']).to eq('newuser@example.com')
      end
    end

    context 'when request is invalid' do
      it 'returns an error for missing email' do
        invalid_attributes = { user: { email: '', password: 'password', password_confirmation: 'password' } }

        post '/register', params: invalid_attributes.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Email can't be blank")
      end

      it 'returns an error for password mismatch' do
        invalid_attributes = { user: { email: 'user@example.com', password: 'password', password_confirmation: 'different_password' } }

        post '/register', params: invalid_attributes.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Password confirmation doesn't match Password")
      end

      it 'returns an error for short password' do
        invalid_attributes = { user: { email: 'user@example.com', password: '123', password_confirmation: '123' } }

        post '/register', params: invalid_attributes.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include('Password is too short (minimum is 6 characters)')
      end
    end
  end
end
