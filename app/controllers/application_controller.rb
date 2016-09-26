class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user(remote: false)
    unless logged_in?
      access_denied 'You must be logged in to do that.', remote: remote
    end
  end

  def require_logged_out
    access_denied('You must be logged out to do that.') if logged_in?
  end

  def require_logged_in_as(authorized_users, remote: false)
    unless authorized_users.respond_to?(:each)
      authorized_users = [authorized_users]
    end

    unless authorized_users.include? current_user
      access_denied remote: remote
      return false
    end

    return true
  end

  def access_denied(msg = "You aren't allowed to do that.", remote: false)
    if remote
      render json: { error: msg }, status: :forbidden
    else
      flash[:danger] = msg
      redirect_to root_path
    end
  end
end
