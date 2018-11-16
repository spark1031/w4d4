class ApplicationController < ActionController::Base
  helper_method :current_user
  #cookies logic goes here:
  # => resets user's session token
  # => assigns session[:session_token] to match user's new session token
  def log_in_user!(user)
    session[:session_token] = user.reset_session_token!
  end

  #find current_user using :session_token info
  #conditionally set this user to @current_user
  def current_user
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logout!
    session[:session_token] = nil

    #if there is a current_user, we reset her session_token
    current_user.reset_session_token! if current_user

    @current_user = nil
  end

  def logged_in?
    @current_user.nil? ? false : true
  end
end
