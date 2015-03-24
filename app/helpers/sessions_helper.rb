# SessionsHelper
module SessionsHelper
  def log_in(user)
    session[:user_id] = user._id
  end

  def current_user
    @current_user ||= ApplicationUser.find_by_id(session[:user_id])
  end
end
