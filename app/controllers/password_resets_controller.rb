class PasswordResetsController < ApplicationController
  before_action :require_logged_out
  before_action :set_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:email]

    if @user
      @user.create_reset_token
      UserMailer.password_reset(@user).deliver_now
    end

    flash[:info] = 'If your email is in our system, you should be receiving information to reset your password shortly. Please check your email.'
    redirect_to root_path
  end

  def edit
  end

  def update
    if @user.update user_params
      flash[:success] = 'Password successfully reset.'
      UserMailer.password_change_notification(@user).deliver_now
      redirect_to login_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def set_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_path
    end
  end

  def check_expiration
    if @user.reset_expired?
      flash[:danger] = 'Password reset expired.'
      redirect_to(new_password_reset_path)
    end
  end
end
