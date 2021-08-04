require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:user) { create(:user) }
  let(:extra_user) { create(:user, email: 'dia@bom') }

  describe 'POST /create' do
    it 'creates normal user' do
      post '/api/v1/user/create', params: {
        user: {
          name: 'Bom dia',
          email: 'bom@dia',
          password: '123456'
        }
      }
      expect(response).to have_http_status(:created)
    end

    it 'user with duplicate email' do
      post '/api/v1/user/create', params: {
        user: {
          name: 'Bom dia',
          email: user.email,
          password: '123456'
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'try to create admin' do
      post '/api/v1/user/create', params: {
        user: {
          name: 'Bom dia',
          email: 'bom@dia',
          password: '123456',
          is_admin: true
        }
      }
      expect(response).to have_http_status(:created)
      expect(User.find_by(email: 'bom@dia').is_admin).to be_falsey
    end
  end

  describe 'PUT /update' do
    it 'authenticated user with valid params' do
      put '/api/v1/user/update', params: {
        user: {
          name: 'potato'
        }
      }, headers: {
        'X-User-Token': user.authentication_token,
        'X-User-Email': user.email
      }
      expect(response).to have_http_status(:ok)
      expect(User.find(user.id).name).to be_eql('potato')
    end

    it 'authenticated user with invalid params' do
      put '/api/v1/user/update', params: {
        user: {
          email: extra_user.email
        }
      }, headers: {
        'X-User-Token': user.authentication_token,
        'X-User-Email': user.email
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'unauthenticated user' do
      put '/api/v1/user/update', params: {
        user: {
          email: extra_user.email
        }
      }, headers: {
        'X-User-Token': "#{user.authentication_token}/",
        'X-User-Email': user.email
      }
      expect(response).to redirect_to authentication_failure_path
    end
  end

  describe 'GET /show' do
    let(:expected) do
      {
        id: user.id,
        name: user.name,
        email: user.email,
        authentication_token: user.authentication_token,
        is_admin: user.is_admin
      }.to_json
    end

    it 'authenticated user' do
      get '/api/v1/user/show', headers: {
        'X-User-Token': user.authentication_token,
        'X-User-Email': user.email
      }
      expect(response).to have_http_status(:ok)
      expect(response.body).to be_eql(expected)
    end

    it 'unauthenticated user' do
      get '/api/v1/user/show', headers: {
        'X-User-Token': "#{user.authentication_token}/",
        'X-User-Email': user.email
      }
      expect(response).to redirect_to authentication_failure_path
    end
  end

  describe 'DELETE /delete' do
    it 'authenticated user' do
      delete '/api/v1/user/delete', headers: {
        'X-User-Token': user.authentication_token,
        'X-User-Email': user.email
      }
      expect(response).to have_http_status(:ok)
      expect(User.all.map(&:id)).to_not include(user.id)
    end

    it 'unauthenticated user' do
      delete '/api/v1/user/delete', headers: {
        'X-User-Token': "#{user.authentication_token}/",
        'X-User-Email': user.email
      }
      expect(response).to redirect_to authentication_failure_path
    end
  end
end
