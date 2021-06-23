class Api::V1::SessionsController < ApplicationController
  acts_as_token_authentication_handler_for User, only: :logout, fallback: :devise

  def login
    user = User.find_by(email: params[:email])
    if user.valid_password?(params[:password])
      render json: user
    else
      head(:unauthorized)
    end
  rescue StandardError => e
    render json: { message: 'usuário não encontrado' }, status: :not_found
  end

  def logout
    if current_user
      current_user.authentication_token = nil
      current_user.save!
      head(:ok)
    else
      render json: { message: 'usuário não encontrado' }, status: :not_found
    end
  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end
end
