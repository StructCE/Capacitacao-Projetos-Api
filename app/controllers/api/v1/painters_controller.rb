class Api::V1::PaintersController < ApplicationController
    acts_as_token_authentication_handler_for User, only: %i[create update delete], fallback: :devise
    before_action :is_admin, only: %i[create update delete]

    def index
        painters = Painter.all
        render json: painters, status: :ok
    end

    def create
        painter = Painter.new(painter_params)
        painter.save!

        render json: painter, status: :created
    rescue StandardError => e
        render json: {message: e.message}, status: :bad_request
    end

    def show
        painter = Painter.find(params[:id])
        render json: painter, status: :ok
    rescue StandardError => e
        render json: {message: 'Não foi possível encontrar o artista'}, status: :bad_request
    end

    def update
        painter = Painter.find(params[:id])
        painter.update!(painter_params)

        render json: painter, status: :ok
    rescue StandardError => e
        render json: {message: 'Não foi possível atualizar o artista'}, status: :bad_request
    end

    def delete
        painter = Painter.find(params[:id])
        painter.destroy!

        render painter, status: :ok
    rescue StandardError => e
        render json: {message: 'Não foi possível excluir o artista'}, status: :bad_request
    end

    private

    def painter_params
        params.require(:painter).permit(
            :name,
            :bio,
            :born,
            :died
        )
    end

end