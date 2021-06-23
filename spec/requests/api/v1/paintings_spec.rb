require 'rails_helper'

RSpec.describe "Api::V1::Paintings", type: :request do
  let(:pintor) { create(:painter) }
  let(:estilo) { create(:style) }

  context 'GET #Index' do
    it 'should render all paintings' do
      get '/api/v1/paintings/index'
      expect(response).to have_http_status(:success)
    end
  end

  context 'POST #Create' do
    let(:painting_params) do
      { name:"Pintura", time_of_completion:'1506-02-18', painter_id: pintor.id, style_id: estilo.id}
    end

    it 'should create a painting' do
      post '/api/v1/paintings/create', params: { painting: painting_params }
      expect(response).to have_http_status(:success)
    end

    it 'should not create a painting' do
      painting_params = {name: 'oi'}
      post '/api/v1/paintings/create', params: { painting: painting_params }
      expect(response).to have_http_status(:bad_request)
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

    it 'should update painting info' do 
      patch "/api/v1/paintings/update/#{pintura.id}", params: { painting: atualizado }
      pintura.reload
      expect(response).to have_http_status(:ok)
    end

    it 'should not update info' do 
      patch "/api/v1/paintings/update/2", params: { painting: atualizado }
      pintura.reload
      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'DELETE #Delete' do 
    let(:pintura) { create(:painting, painter_id: pintor.id, style_id: estilo.id) }

    it 'should delete painting' do 
      delete "/api/v1/paintings/delete/#{pintura.id}", params: { id: pintura.id }
      expect(response).to have_http_status(:ok)
    end

    it 'should not delete' do 
      pintura.destroy!
      delete "/api/v1/paintings/delete/#{pintura.id}", params: { id: pintura.id }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
