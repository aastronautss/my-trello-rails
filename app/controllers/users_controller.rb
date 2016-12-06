class UsersController < ApplicationController
  before_action :require_logged_out, only: [:new, :create]
  before_action :require_user, only: [:edit, :update]
  before_action :require_activated_user, only: [:edit, :update]

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

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update update_user_params
      flash[:success] = 'Account successfully updated!'
      redirect_to my_account_path
    else
      render :edit
    end
  end

  private

  def update_user_params
    params.require(:user).permit :email, :password, :password_confirmation
  end

  def user_params
    params.require(:user).permit :email, :username, :password, :password_confirmation
  end
end
