class BoardMembershipsController < ApplicationController
  before_action :set_board
  before_action :require_user
  before_action -> { require_logged_in_as @board.admins }
  before_action -> { require_plan_level 'plus' }

  def create
    user = find_user(params[:username])

    if user && @board.add_member(user)
      flash[:success] = "#{user.username} successfully added!"
    else
      flash[:danger] = 'There was an error adding the user.'
    end

    redirect_to @board
  end

  def destroy
    user = find_user(params[:username])
    @board.remove_member user
    redirect_to @board
  end

  private

  def set_board
    @board = Board.find_by token: params[:id]
  end
end
