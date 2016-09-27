class ListsController < ApplicationController
  before_action -> { require_user remote: true }
  before_action :set_list, except: [:new, :create, :index]

  def index
    board = Board.find params[:board_id]
    @lists = board.lists
    # TODO: Find a more elegent way to halt the action.
    return unless require_logged_in_as board.members, remote: true
  end

  def show
    return unless require_logged_in_as @list.board.members, remote: true
  end

  def create
    @list = List.new list_params
    @list.position = @list.board.next_list_position
    return unless require_logged_in_as @list.board.members, remote: true

    if @list.save
      render template: 'lists/show', status: :created, location: @list
    else
      render json: @list.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    return unless require_logged_in_as @list.board.members, remote: true

    if @list.update list_params
      @list.board.normalize_list_positions
      @list.reload
      render template: 'lists/show', status: :ok, location: @list
    else
      render json: @list.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    return unless require_logged_in_as @list.board.members, remote: true

    if @list.destroy
      head :no_content
    else
      render json: @list.errors.full_messages, status: :unprocessable_entity
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
