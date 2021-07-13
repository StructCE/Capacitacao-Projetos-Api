class ApplicationController < ActionController::API
  acts_as_token_authentication_handler_for User, only: :is_admin, fallback: :devise

  def authentication_failure
    render json: { message: 'User authentication failure' }, status: :unauthorized
  end

  def is_admin
    render json: { message: 'You are not allowed to do that!' }, status: :unauthorized unless current_user.is_admin
  end
end
