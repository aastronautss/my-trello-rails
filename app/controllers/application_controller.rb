class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find(user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find user_id
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def log_out
    forget(current_user)
    session[:user_id] = nil
    @current_user = nil
  end

  def forget(user)
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
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

  def require_activated_user(remote: false)
    unless current_user.activated?
      message = 'Your account must be activated to do that.'
      access_denied message, remote: remote
    end
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
