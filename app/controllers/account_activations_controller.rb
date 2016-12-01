class AccountActivationsController < ApplicationController
  before_action :require_logged_out

  def edit
    user = User.find_by email: params[:email]

    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate!
      log_in user
      flash[:success] = 'Account activation successful! Welcome to My Trello.'
    else
      flash[:danger] = 'Invalid activation link.'
    end

    redirect_to root_path
  end
end
