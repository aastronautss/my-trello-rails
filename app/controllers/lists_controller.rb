class ListsController < ApplicationController
  before_action :set_list, except: [:new, :create]
  before_action :require_user

  def new
    board = Board.find params[:board_id]
    @list = List.new board: board
    require_logged_in_as(board.members)
  end

  def create
    @list = List.new list_params
    require_logged_in_as @list.board.members

    if @list.save
      flash[:success] = 'Your list was created.'
      redirect_to board_path(@list.board)
    else
      render :new
    end
  end

  private

  def list_params
    params.require(:list).permit(:title, :board_id)
  end

  def set_list
    @list = List.find params[:id]
  end
end
