require 'rails_helper'

RSpec.describe "Api::V1::Galleries", type: :request do
  let(:user) { create(:user) }
  let(:painter) { create(:painter) }
  let(:style) { create(:style) }
  let(:painting) { create(:painting, painter_id: painter.id, style_id: style.id) }
  let(:authentication_headers) do
    {'X-User-Email': user.email, 'X-User-Token': user.authentication_token}
  end
  let(:gallery) { create(:gallery, user_id: user.id) }

  describe "POST /create" do
    context 'without user logged in' do
      it 'should redirect to authentication failure' do
        post '/api/v1/gallery/create', params: {
          gallery: {
            name: 'Galleria',
            user_id: user.id
          }
        }
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with user logged in' do
      it 'should create' do
        post '/api/v1/gallery/create', params: {
          gallery: {
            name: 'Galleria',
            user_id: user.id
          }
        }, headers: authentication_headers
        expect(response).to have_http_status :created
      end

      it 'should fail creation' do
        post '/api/v1/gallery/create', params: {
          gallery: {
            name: 'Galleria',
            user_id: user.id + 1
          }
        }, headers: authentication_headers
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe "PUT /update" do
    context 'without user logged in' do
      it 'should redirect to authentication failure' do
        put "/api/v1/gallery/update/#{gallery.id}", params: {
          gallery: {
            name: 'Galleria',
            user_id: user.id
          }
        }
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with user logged in' do
      it 'should edit' do
        put "/api/v1/gallery/update/#{gallery.id}", params: {
          gallery: {
            name: 'Galleria',
            user_id: user.id
          }
        }, headers: authentication_headers
        expect(response).to have_http_status :ok
      end

      it 'should fail creation' do
        put "/api/v1/gallery/update/#{gallery.id}", params: {
          gallery: {
            name: 'Galleria',
            user_id: user.id + 1
          }
        }, headers: authentication_headers
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'GET /index' do
    context 'without user logged in' do
      it 'should redirect to unauthorized' do
        get '/api/v1/gallery/index'
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with user logged in' do
      it 'should work' do
        get '/api/v1/gallery/index', headers: authentication_headers
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'GET /show' do
    context 'without user logged in' do
      it 'should redirect to unauthorized' do
        get "/api/v1/gallery/show/#{gallery.id}"
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with user logged in' do
      it 'should work' do
        get "/api/v1/gallery/show/#{gallery.id}", headers: authentication_headers
        expect(response).to have_http_status :ok
      end

      it 'should return 404' do
        get "/api/v1/gallery/show/#{gallery.id + 1}", headers: authentication_headers
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'DELETE /delete' do
    context 'without user logged in' do
      it 'should render bad request' do 
        delete "/api/v1/gallery/delete/#{gallery.id}"
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with user logged in' do 
      it 'should work' do 
        delete "/api/v1/gallery/delete/#{gallery.id}", headers: authentication_headers
        expect(response).to have_http_status :ok
      end

      it 'should return an error' do 
        delete "/api/v1/gallery/delete/#{gallery.id + 1}", headers: authentication_headers
        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe 'POST /link painting' do
    context 'without user logged in' do
      it 'should fail' do 
        post "/api/v1/gallery/link_painting"
        expect(response).to redirect_to authentication_failure_path
      end
    end

    context 'with logged user' do
      it 'should render ok' do
        post "/api/v1/gallery/link_painting", params: {
          painting_id: painting.id, gallery_id: gallery.id
        }, headers: authentication_headers
        expect(response).to have_http_status :ok
      end
    end
  end
end
