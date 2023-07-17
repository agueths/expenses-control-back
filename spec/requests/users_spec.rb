require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:valid_params) do
    {
      username: 'UserLoginTest',
      password: '123456'
    }
  end
  describe 'POST /authenticate' do
    let(:invalid_params) do
      {
        username: 'UserLoginTest',
        password: '456789'
      }
    end
    context 'with valid attributes' do
      it 'returns http success and return a JSON with the user and a token' do
        User.create(username: 'UserLoginTest', password: '123456', password_confirmation: '123456')
        post '/users/authenticate', params: valid_params, headers: {}, as: :json
        expect(response).to have_http_status(:success)
        expect(response.parsed_body).to be_a_kind_of(Hash)
        expect(response.parsed_body).to have_key('user')
        expect(response.parsed_body['user']).to be_a_kind_of(Hash)
        expect(response.parsed_body['user']).to have_key('username')
        expect(response.parsed_body['user']['username']).to eq('UserLoginTest')
        expect(response.parsed_body).to have_key('token')
        expect(response.parsed_body['token']).to be_a_kind_of(String)
      end
    end
    context 'with invalid attributes' do
      User.create(username: 'UserLoginTest', password: '123456', password_confirmation: '123456')
      it 'return http client error' do
        post '/users/authenticate', params: invalid_params, headers: {}, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /token_validation' do
    it 'return http success and return a JSON with the user' do
      User.create(username: 'UserLoginTest', password: '123456', password_confirmation: '123456')
      post '/users/authenticate', params: valid_params, headers: {}, as: :json
      token = response.parsed_body['token']
      get '/users/token_validation', params: {}, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
      expect(response.parsed_body).to be_a_kind_of(Hash)
      expect(response.parsed_body).to have_key('user')
      expect(response.parsed_body['user']).to be_a_kind_of(Hash)
      expect(response.parsed_body['user']).to have_key('username')
      expect(response.parsed_body['user']['username']).to eq('UserLoginTest')
    end
  end
end
