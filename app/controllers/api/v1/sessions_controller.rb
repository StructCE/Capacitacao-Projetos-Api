class Api::V1::SessionsController < ApplicationController
  acts_as_token_authentication_handler_for User, only: :logout

  def login
    user = User.find_by(email: params[:email])
    if user.valid_password?(params[:password])
      render json: user
    else
      head(:unauthorized)
    end
  end

  def logout
    current_user.authentication_token = nil
    current_user.save!
    head(:ok)
  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end
end
