class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  skip_before_action :authenticate_request
  attr_reader :current_user

  protected

  def authorize
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV_PROP['username'] && password == ENV_PROP['password']
    end
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.header).result
    render json: {error: 'not authorized'}, status: 401 unless @current_user
  end
end
