class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize( header = {} )
    @header = header
  end

  def call
    user
  end

  private

  attr_reader :header

  def user
    @user ||= User.find(decode_auth_token[:user_id]) if decode_auth_token
    @user || errors.add(:token, 'Invalid token') && nil
  end

  def decode_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if header['Authorization'].present?
      return header['Authorization'].split.last
    else
      errors.add(:token, 'missing token')
    end
    nil
  end
end