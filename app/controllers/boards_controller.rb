class BoardsController < ApplicationController
  before_action :set_board, except: [:new, :create, :index]
  before_action :require_user, only: [:new, :create]
  before_action -> { require_logged_in_as @board.members }, only: [:show]

  def show
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new board_params

    if @board.save
      board_membership = BoardMembership.new user_id: current_user.id,
                                           board_id: @board.id,
                                           admin: true,
                                           owner: true
      board_membership.save

      flash[:success] = 'Your board was created.'
      redirect_to board_path(@board)
    else
      render :new
    end
  end

  private

  def board_params
    params.require(:board).permit(:name)
  end

  def set_board
    @board = Board.find params[:id]
  end
end
