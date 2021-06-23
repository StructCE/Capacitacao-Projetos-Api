class ApplicationController < ActionController::API
  def authentication_failure
    render json: { message: 'User authentication failure' }, status: :unauthorized
  end
end
