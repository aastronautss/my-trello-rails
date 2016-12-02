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

    flash[:info] = 'Please check your email to reset your password.'
    redirect_to root_path
  end

  def edit
  end

  private

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
