class BoardMembershipsController < ApplicationController
  before_action :set_board
  before_action :set_user
  before_action :require_user
  before_action -> { require_logged_in_as @board.admins }

  def create
    admin = board_membership_params[:admin].nil? ? false : board_membership_params[:admin]

    @board.add_member @user, admin
    redirect_to @board
  end

  def destroy
    @board.remove_member @user
    redirect_to @board
  end

  private

  def board_membership_params
    params.require(:board_membership).permit(:board_id, :user_id, :admin)
  end

  def set_board
    @board = Board.find board_membership_params[:board_id]
  end

  def set_user
    @user = User.find board_membership_params[:user_id]
  end
end
