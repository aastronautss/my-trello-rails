class ListsController < ApplicationController
  before_action :set_list, except: [:new, :create, :index]
  before_action :require_user

  def index
    board = Board.find params[:board_id]
    @lists = List.where board: board
    require_logged_in_as board.members

    respond_to do |format|
      format.json { render json: @lists }
    end
  end

  # def new
  #   board = Board.find params[:board_id]
  #   @list = List.new board: board
  #   require_logged_in_as board.members
  # end

  def create
    @list = List.new list_params
    require_logged_in_as @list.board.members

    respond_to do |format|
      if @list.save
        format.html do
          flash[:success] = 'Your list was created.'
          redirect_to board_path(@list.board)
        end

        format.json { render json: @list, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors.full_messages,
                        status: :unprocessable_entity }
      end
    end
  end

  def update
    require_logged_in_as @list.board.members

    if @list.update list_params
      render json: @list, status: :ok, location: @list
    else
      render json: @list.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    require_logged_in_as @list.board.members

    respond_to do |format|
      if @list.destroy
        format.json { head :no_content }
      else
        format.json { render json: @list.errors.full_messages,
                        status: :unprocessable_entity }
      end
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
