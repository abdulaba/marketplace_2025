module Authenticable
  def current_user
    return @current_user if @current_user

    token = request.headers["Authorization"].split(" ").last
    return nil if token.nil?

    decoded = JsonWebTokenService.decode(token)
    @current_user = User.find(decoded["user"])
    binding.break
    rescue
      ActiveRecord::RecordNotFound
      nil
  end

  def authenticate_user!
    head :unauthorized unless current_user
  end

end
