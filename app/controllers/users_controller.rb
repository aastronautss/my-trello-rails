class UsersController < ApplicationController
  before_action :require_logged_out

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :email, :username, :password, :password_confirmation
  end
end
