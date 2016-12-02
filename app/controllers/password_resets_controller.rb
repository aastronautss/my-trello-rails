class PasswordResetsController < ApplicationController
  before_action :require_logged_out

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
end
