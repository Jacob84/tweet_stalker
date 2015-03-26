# SessionsHelper
module SessionsHelper
  def log_in(user)
    session[:user_id] = user._id
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    @current_user ||= ApplicationUser.find_by_id(session[:user_id])
  end

  def test_logged_in
    redirect_to '/' unless logged_in?
  end

  def logged_in?
    !current_user.nil?
  end
end
