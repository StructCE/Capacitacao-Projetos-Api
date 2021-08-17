class Api::V1::StyleController < ApplicationController
  acts_as_token_authentication_handler_for User, only: %i[create update delete], fallback: :devise
  before_action :is_admin, only: %i[create update delete]

  def create
    style = Style.new(style_params)
    style.save!
    attach_photo(style)
    render json: style, status: :created
  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  def update
    style = Style.find(params[:id])
    style.update!(style_params)
    attach_photo(style)
    render json: style
  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  def delete
    style = Style.find(params[:id])
    style.destroy!
    head :ok
  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  def index
    styles = Style.all

    render json: styles, status: :ok
  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  def show
    style = Style.find(params[:id])

    render json: style, status: :ok
  rescue StandardError => e
    render json: { message: e.message }, status: :not_found
  end

  def add_photo
    style = Style.find(params[:id])
    style.photo.attach(params[:photo])

    render json: params[:photo], status: :ok
  rescue StandardError => e
    render json: { message: 'Não foi possível adicionar a foto' }, status: :bad_request
  end

  private

  def style_params
    params.require(:style).permit(
      :name,
      :description
    )
  end

  def attach_photo(style)
    style.photo.attach(params[:photo]) if params[:photo]
  end
end
