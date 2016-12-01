class SessionsController < ApplicationController
  before_action :require_logged_out, only: [:new, :create]
  before_action :require_user, only: [:destroy]

  def new
  end

  def create
    user = User.find_by username: params[:username]

    if user && user.authenticate(params[:password])
      log_in user
      params[:remember] == '1' ? remember(user) : forget(user)
      flash[:success] = 'You have successfully logged in.'
      redirect_to root_path
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
