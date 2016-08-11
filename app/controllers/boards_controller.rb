class BoardsController < ApplicationController
  before_action :set_board, except: [:new, :create, :index]

  def show
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new board_params

    if @board.save
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
