class BoardMembershipsController < ApplicationController
  before_action :set_board
  before_action :require_user
  before_action -> { require_logged_in_as @board.admins }

  def create
    user = User.find_by username: params[:username]

    if user && @board.add_member(user)
      flash[:success] = "#{user.username} successfully added!"
    else
      flash[:danger] = 'There was an error adding the user.'
    end

    redirect_to @board
  end

  def destroy
    user = User.find_by username: params[:username]
    @board.remove_member user
    redirect_to @board
  end

  private

  def set_board
    @board = Board.find_by token: params[:id]
  end
end
