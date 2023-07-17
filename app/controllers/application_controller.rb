class ApplicationController < ActionController::API
  rescue_from Exception, with: :show_error

  def authorized_user?
    auth_header = request.headers['Authorization']
    return false unless auth_header

    token = auth_header.split(' ').last
    payload = Tokenization.decode(token)
    return false if payload[:error]

    params[:token] = payload
    true
  end

  def authorization_required
    return if authorized_user?

    render json: {
             method: 'api#authorization_required',
             error: 'authentication not found'
           },
           status: :unauthorized
  end

  def show_error(e)
    render json: {
             method: 'api#internal_error',
             error: e,
             backtrace: e.backtrace # development only
           },
           status: :internal_server_error
  end
end
