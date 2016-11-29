class UsersController < ApplicationController
  before_action :require_logged_out

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = 'Registration successful! You are now logged in.'
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :username, :password, :password_confirmation
  end
end
