class Api::V1::UserController < ApplicationController
  acts_as_token_authentication_handler_for User, only: %i[update destroy show add_picture], fallback: :devise

  def create
    user = User.new(user_params)
    user.save!
    render json: user, status: :created
  rescue StandardError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def update
    current_user.update!(user_params)
    render json: current_user
  rescue StandardError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def show
    render json: current_user
  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  def destroy
    current_user.destroy!
    head(:ok)
  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  def token_fallback
    render json: { message: 'Invalid Token!' }, status: :unauthorized
  end

  def add_picture
    current_user.photo.attach(params[:photo]) if params[:photo]
    #  render json: current_user
  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password
    )
  end
end
