class AdminInvitationsController < ApplicationController
  before_action :require_logged_out
  before_action :set_user
  before_action :valid_user

  def edit
  end

  def update
    if @user.update user_params
      @user.activate!
      flash[:success] = 'Account activated! You may now log in.'
      redirect_to login_path
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find_by email: params[:email]
  end

  def user_params
    user = params.require(:user).permit :password, :password_confirmation
    user.each { |k, v| user[k] = 'a' if v.blank? }
    user
  end

  def valid_user
    unless @user && @user.authenticated?(:reset, params[:id])
      redirect_to root_path
    end
  end
end
