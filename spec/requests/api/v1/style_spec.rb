require 'rails_helper'

RSpec.describe 'Api::V1::Styles', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, is_admin: true) }

  describe 'POST create' do
    let(:style_params) do
      {
        name: 'Futurismo',
        description: 'Movimento artístico que foca no movimento, progresso e violência.'
      }
    end

    context 'without user logged in' do
      it 'should redirect to authentication failure' do
        post '/api/v1/style/create', params: { style: style_params }
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with regular user logged in' do
      it 'should return unauthorized' do
        post '/api/v1/style/create', params: { style: style_params }, headers: {
          'X-User-Token': user.authentication_token,
          'X-User-Email': user.email
        }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with admin logged in' do
      it 'should create style' do
        post '/api/v1/style/create', params: { style: style_params }, headers: {
          'X-User-Token': admin.authentication_token,
          'X-User-Email': admin.email
        }
        expect(response).to have_http_status :created
      end

      it 'should return bad request' do
        style_params[:description] = 'oi'
        post '/api/v1/style/create', params: { style: style_params }, headers: {
          'X-User-Token': admin.authentication_token,
          'X-User-Email': admin.email
        }
        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe 'PUT update' do
    let(:style_params) { { name: 'Futurama' } }
    let(:style) { create(:style) }

    context 'without user logged in' do
      it 'should redirect to authentication failure' do
        put "/api/v1/style/update/#{style.id}", params: { style: style_params }
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with regular user logged in' do
      it 'should return unauthorized' do
        put "/api/v1/style/update/#{style.id}", params: { style: style_params }, headers: {
          'X-User-Token': user.authentication_token,
          'X-User-Email': user.email
        }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with admin logged in' do
      it 'should create style' do
        put "/api/v1/style/update/#{style.id}", params: { style: style_params }, headers: {
          'X-User-Token': admin.authentication_token,
          'X-User-Email': admin.email
        }
        style.reload
        expect(response).to have_http_status :ok
        expect(style.name).to be_eql 'Futurama'
      end

      it 'should return bad request' do
        style_params[:description] = 'oi'
        put "/api/v1/style/update/#{style.id}", params: { style: style_params }, headers: {
          'X-User-Token': admin.authentication_token,
          'X-User-Email': admin.email
        }
        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe 'DELETE delete' do
    let(:style) { create(:style) }

    context 'without user logged in' do
      it 'should redirect to authentication failure' do
        delete "/api/v1/style/delete/#{style.id}"
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with regular user logged in' do
      it 'should return unauthorized' do
        delete "/api/v1/style/delete/#{style.id}", headers: {
          'X-User-Token': user.authentication_token,
          'X-User-Email': user.email
        }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with admin logged in' do
      it 'should create style' do
        delete "/api/v1/style/delete/#{style.id}", headers: {
          'X-User-Token': admin.authentication_token,
          'X-User-Email': admin.email
        }
        style.reload
        expect(response).to have_http_status :ok
        expect(style.name).to be_eql 'Futurama'
      end

      it 'should return bad request' do
        delete "/api/v1/style/delete/#{style.id + 1}", headers: {
          'X-User-Token': admin.authentication_token,
          'X-User-Email': admin.email
        }
        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe 'GET index' do
    it 'should return ok' do
      get '/api/v1/style/index'
      expect(response).to have_http_status :ok
    end
  end

  describe 'GET show' do
    let(:style) { create(:style) }

    it 'should return ok' do
      get "/api/v1/style/show/#{style.id}"
      expect(response).to have_http_status :ok
    end

    it 'should return not found' do
      get "/api/v1/style/show/#{style.id + 1}"
      expect(response).to have_http_status :not_found
    end
  end
end
