require 'rails_helper'

RSpec.describe 'Api::V1::Painters', type: :request do
  let(:admin) { create(:user, is_admin: true) }
  let(:user) { create(:user) }

  context 'GET /index' do
    it 'should render all painters' do
      get '/api/v1/painter/index'
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST /create' do
    let(:painter_params) do
      { name: 'Caravaggio', bio: 'Pintor barroco com foco em obras mais escuras', born: Time.now, died: Time.now }
    end

    context 'without user logged in' do
      it 'should redirect to failure' do
        post '/api/v1/painter/create', params: { painter: painter_params }
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with regular user' do
      it 'should redirect to failure' do
        post '/api/v1/painter/create', params: { painter: painter_params }, headers: {
          "X-User-Token": user.authentication_token,
          "X-User-Email": user.email
        }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'With admin user' do
      it 'should create a painter' do
        post '/api/v1/painter/create', params: { painter: painter_params }, headers: {
          "X-User-Token": admin.authentication_token,
          "X-User-Email": admin.email
        }
        expect(response).to have_http_status(:created)
      end

      it 'should not create a painter' do
        painter_params = { name: 24 }
        post '/api/v1/painter/create', params: { painter: painter_params }, headers: {
          "X-User-Token": admin.authentication_token,
          "X-User-Email": admin.email
        }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  context 'GET #Show' do
    it 'with existing painter' do
      pintor = create(:painter)
      get "/api/v1/painter/show/#{pintor.id}"
      expect(response).to have_http_status(:ok)
    end

    it 'with non existing painter' do
      get '/api/v1/painter/show/1'
      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'PUT /update' do
    let(:painter_params) { { name: 'Aleijadinho' } }
    let(:painter) { create(:painter) }

    context 'without user logged in' do
      it 'should redirect to authentication failure' do
        put "/api/v1/painter/update/#{painter.id}", params: { painter: painter_params }
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with regular user logged in' do
      it 'should return unauthorized' do
        put "/api/v1/painter/update/#{painter.id}", params: { painter: painter_params }, headers: {
          'X-User-Token': user.authentication_token,
          'X-User-Email': user.email
        }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with admin logged in' do
      it 'should update painter' do
        put "/api/v1/painter/update/#{painter.id}", params: { painter: painter_params }, headers: {
          'X-User-Token': admin.authentication_token,
          'X-User-Email': admin.email
        }
        painter.reload
        expect(response).to have_http_status :ok
        expect(painter.name).to be_eql 'Aleijadinho'
      end

      it 'should return bad request' do
        painter_params[:born] = 'data invalida'
        put "/api/v1/painter/update/#{painter.id}", params: { painter: painter_params }, headers: {
          'X-User-Token': admin.authentication_token,
          'X-User-Email': admin.email
        }
        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe 'DELETE delete' do
    let(:painter) { create(:painter) }

    context 'without user logged in' do
      it 'should redirect to authentication failure' do
        delete "/api/v1/painter/delete/#{painter.id}"
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with regular user logged in' do
      it 'should return unauthorized' do
        delete "/api/v1/painter/delete/#{painter.id}", headers: {
          'X-User-Token': user.authentication_token,
          'X-User-Email': user.email
        }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with admin logged in' do
      it 'should delete painter' do
        delete "/api/v1/painter/delete/#{painter.id}", headers: {
          'X-User-Token': admin.authentication_token,
          'X-User-Email': admin.email
        }
        expect(response).to have_http_status :ok
      end
    end

    it 'should return bad request' do
      delete "/api/v1/painter/delete/#{painter.id + 1}", headers: {
        'X-User-Token': admin.authentication_token,
        'X-User-Email': admin.email
      }
      expect(response).to have_http_status :bad_request
    end
  end
end
