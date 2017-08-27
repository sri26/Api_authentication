class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
  before_action :authorize

  def authenticate
    authorize = AuthorizeUser.call(params[:email], params[:password])

    if authorize.success?
      render json: {message: "Hey you are authorized user"}
    else
      render json: { error: authorize.errors }, status: :unauthorized
    end
  end
end