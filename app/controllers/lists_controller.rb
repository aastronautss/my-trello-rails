class ListsController < ApplicationController
  before_action :set_list, except: [:new, :create]

  def new
    @list = List.new board_id: params[:board_id]
  end

  def create
    @list = List.new list_params

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
