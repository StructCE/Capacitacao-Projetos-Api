class Api::V1::GalleryController < ApplicationController
  acts_as_token_authentication_handler_for User, fallback: :devise

  def create
    gallery = Gallery.new(gallery_params)

    gallery.save!

    render json: gallery, status: :created
  rescue StandardError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def index
    galleries = current_user.galleries
    render json: galleries, status: :ok
  end

  def show
    gallery = Gallery.find(params[:id])
    render json: gallery, status: :ok
  rescue StandardError => e
    head(:not_found)
  end

  def update
    gallery = Gallery.find(params[:id])

    gallery.update!(gallery_params)

    render json: gallery, status: :ok
  rescue StandardError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def delete
    gallery = Gallery.find(params[:id])

    gallery.destroy!

    head(:ok)
  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  def add_photo
    gallery = Gallery.find(params[:id])
    gallery.photo.attach(params[:photo]) if params[:photo]
  end

  def link_painting
    gallery = Gallery.find(params[:gallery_id])
    painting = Painting.find(params[:painting_id])

    gallery_painting = GalleryPainting.new(gallery_id: gallery.id, painting_id: painting.id)

    gallery_painting.save!

    render json: gallery, status: :ok
  rescue StandardError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  private

  def gallery_params
    params.require(:gallery).permit(
      :name,
      :user_id
    )
  end
end
