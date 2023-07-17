class UsersController < ApplicationController
  before_action :authorization_required, except: %i[authenticate forgot_password]

  def authenticate
    render json: {}, status: :unauthorized unless params.key?(:username) && params.key?(:password)
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      render json: {
        user: user.token_data,
        token: Tokenization.encode(user.token_data)
      }, status: :ok
    else
      render json: {}, status: :unauthorized
    end
  end

  def token_validation
    return render json: {}, status: :unauthorized unless params.key?(:token)

    render json: { user: params[:token]['payload'] }, status: :ok
  end
end
