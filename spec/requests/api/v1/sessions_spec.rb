require 'rails_helper'

RSpec.describe 'Api::V1::Sessions', type: :request do
  describe 'GET /login' do
    let(:user) { create(:user) }

    it 'user with correct password' do
      get '/api/v1/login', params: {
        email: user.email,
        password: '123456'
      }
      expect(response).to have_http_status(:ok)
    end

    it 'user with incorrect password' do
      get '/api/v1/login', params: {
        email: user.email,
        password: '1234567'
      }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'uninitialized user' do
      get '/api/v1/login', params: {
        email: 'bom@dia',
        password: '123456'
      }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /logout' do
    let(:user) { create(:user) }

    it 'logged user' do
      get '/api/v1/logout', headers: {
        'X-User-Token': user.authentication_token,
        'X-User-Email': user.email
      }
      expect(response).to have_http_status(:ok)
    end

    it 'user with wrong token' do
      get '/api/v1/logout', headers: {
        'X-User-Token': "#{user.authentication_token}/",
        'X-User-Email': user.email
      }
      expect(response).to have_http_status(:found) # found is a redirect status, due to authentication failure
    end

    it 'uninitialized user ' do
      get '/api/v1/logout', headers: {
        'X-User-Token': user.authentication_token,
        'X-User-Email': 'bom@dia.dia'
      }
      expect(response).to have_http_status(:found) # found is a redirect status, due to authentication failure
    end
  end
end
