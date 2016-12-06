class SessionsController < ApplicationController
  before_action :require_logged_out, only: [:new, :create]
  before_action :require_user, only: [:destroy]

  def new
  end

  def create
    user = find_user(params[:username])

    if user && user.authenticate(params[:password])
      if user.activated?
        log_in user
        params[:remember] == '1' ? remember(user) : forget(user)
        flash[:success] = 'You have successfully logged in.'
        redirect_to root_path
      else
        flash[:warning] = 'Account not activated. Check your email for the activation link.'
        redirect_to login_path
      end
    else
      flash[:danger] = "There's something wrong with your username or password."
      redirect_to login_path
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = 'You have successfully logged out.'
    redirect_to root_path
  end
end
