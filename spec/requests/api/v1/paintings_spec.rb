require 'rails_helper'

RSpec.describe 'Api::V1::Paintings', type: :request do
  let(:pintor) { create(:painter) }
  let(:estilo) { create(:style) }
  let(:admin) { create(:user, is_admin: true) }
  let(:user) { create(:user) }

  context 'GET #Index' do
    it 'should render all paintings' do
      get '/api/v1/paintings/index'
      expect(response).to have_http_status(:success)
    end
  end

  context 'POST #Create' do
    let(:painting_params) do
      { name: 'Pintura', time_of_completion: '1506-02-18', painter_id: pintor.id, style_id: estilo.id }
    end

    context 'without user logged in' do
      it 'should redirect to failure' do
        post '/api/v1/paintings/create', params: { painting: painting_params }
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with regular user' do
      it 'should redirect to failure' do
        post '/api/v1/paintings/create', params: { painting: painting_params }, headers: {
          "X-User-Token": user.authentication_token,
          "X-User-Email": user.email
        }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'With admin user' do
      it 'should create a painting' do
        post '/api/v1/paintings/create', params: { painting: painting_params }, headers: {
          "X-User-Token": admin.authentication_token,
          "X-User-Email": admin.email
        }
        expect(response).to have_http_status(:success)
      end

      it 'should not create a painting' do
        painting_params = { name: 'oi' }
        post '/api/v1/paintings/create', params: { painting: painting_params }, headers: {
          "X-User-Token": admin.authentication_token,
          "X-User-Email": admin.email
        }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  context 'GET #Show' do
    let(:pintura) { create(:painting, painter_id: pintor.id, style_id: estilo.id) }

    it 'with existing painting' do
      get "/api/v1/paintings/show/#{pintura.id}"
      expect(response).to have_http_status(:ok)
    end

    it 'with non existing painting' do
      pintura.destroy!
      get "/api/v1/paintings/show/#{pintura.id}"
      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'PATCH #Update' do
    let(:pintura) { create(:painting, painter_id: pintor.id, style_id: estilo.id) }
    atualizado = { name: 'Outra pintura' }

    context 'without user logged in' do
      it 'should redirect to authentication failure' do
        patch "/api/v1/paintings/update/#{pintura.id}", params: { painting: atualizado }
        pintura.reload
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with regular user logged in' do
      it 'should return unauthorized' do
        patch "/api/v1/paintings/update/#{pintura.id}", params: { painting: atualizado }, headers: {
          "X-User-Token": user.authentication_token,
          "X-User-Email": user.email
        }
        pintura.reload
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with admin logged in' do
      it 'should update painting info' do
        patch "/api/v1/paintings/update/#{pintura.id}", params: { painting: atualizado }, headers: {
          "X-User-Token": admin.authentication_token,
          "X-User-Email": admin.email
        }
        pintura.reload
        expect(response).to have_http_status(:ok)
      end

      it 'should not update info' do
        patch '/api/v1/paintings/update/2', params: { painting: atualizado }, headers: {
          "X-User-Token": admin.authentication_token,
          "X-User-Email": admin.email
        }
        pintura.reload
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  context 'DELETE #Delete' do
    let(:pintura) { create(:painting, painter_id: pintor.id, style_id: estilo.id) }

    context 'user not logged in' do
      it 'should redirect to authentication failure' do
        delete "/api/v1/paintings/delete/#{pintura.id}", params: { id: pintura.id }
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'regular user logged in' do
      it 'should receive not authorized' do
        delete "/api/v1/paintings/delete/#{pintura.id}", params: { id: pintura.id }, headers: {
          "X-User-Token": user.authentication_token,
          "X-User-Email": user.email
        }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'admin user logged in' do
      it 'should delete painting' do
        delete "/api/v1/paintings/delete/#{pintura.id}", params: { id: pintura.id }, headers: {
          "X-User-Token": admin.authentication_token,
          "X-User-Email": admin.email
        }
        expect(response).to have_http_status(:ok)
      end

      it 'should not delete' do
        pintura.destroy!
        delete "/api/v1/paintings/delete/#{pintura.id}", params: { id: pintura.id }, headers: {
          "X-User-Token": admin.authentication_token,
          "X-User-Email": admin.email
        }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
