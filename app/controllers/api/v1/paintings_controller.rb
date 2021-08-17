class Api::V1::PaintingsController < ApplicationController
  acts_as_token_authentication_handler_for User, only: %i[create update delete update_picture], fallback: :devise
  before_action :is_admin, only: %i[create update delete]

  def index
    paintings = Painting.all
    render json: paintings, status: :ok
  end

  def create
    painting = Painting.new(painting_params)
    painting.save!

    render json: painting, status: :created
  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  def show
    painting = Painting.find(params[:id])

    render json: painting, status: :ok
  rescue StandardError => e
    render json: { message: 'Não foi possível encontrar a pintura' }, status: :bad_request
  end

  def update
    painting = Painting.find(params[:id])
    painting.update!(painting_params)

    update_picture(true)

    render painting, status: :ok
  rescue StandardError => e
    render json: { message: 'Não foi possível editar a pintura' }, status: :bad_request
  end

  def delete
    painting = Painting.find(params[:id])
    painting.destroy!

    render painting, status: :ok
  rescue StandardError => e
    render json: { message: 'Não foi possível deletar a pintura' }, status: :bad_request
  end

  def update_picture(called = false)
    painting = Painting.find(params[:id])
    painting.painting.attach(params[:picture]) if params[:picture]
    render json: painting unless called
  end

  private

  def painting_params
    params.require(:painting).permit(
      'painter_id',
      'style_id',
      'name',
      'time_of_completion',
      'description'
    )
  end
end
