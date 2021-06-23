class Api::V1::PaintingsController < ApplicationController
    def index 
        paintings = Painting.all 
        render json: paintings, status: :ok
    end

    def create 
        painting = Painting.new(painting_params)
        painting.save!

        render painting, status: :created 
    rescue StandardError => e  
        render json: { message:'Não foi possível criar uma pintura' }, status: :bad_request
    end

    def show
        painting = Painting.find(params[:id])

        render json: painting, status: :ok
    rescue StandardError => e  
        render json: { message:"Não foi possível encontrar a pintura" }, status: :bad_request
    end

    def update
        painting = Painting.find(params[:id])
        painting.update!(painting_params)

        render painting, status: :ok 
    rescue StandardError => e  
        render json: { message:'Não foi possível editar a pintura' }, status: :bad_request
    end

    def delete 
        painting = Painting.find(params[:id])
        painting.destroy!

        render painting, status: :ok 
    rescue StandardError => e  
        render json: { message:'Não foi possível deletar a pintura' }, status: :bad_request
    end

    private 

    def painting_params
        params.require(:painting).permit(
            'painter_id',
            'style_id',
            'name',
            'time_of_completion'
        )
    end
end
