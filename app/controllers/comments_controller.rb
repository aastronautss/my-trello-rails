class CommentsController < ApplicationController
  before_action :require_user

  def index
    board = Board.find params[:board_id]
    require_logged_in_as board.members

    @comments = Comment.joins(card: [list: :board]).
                        where(lists: { board_id: board.id })
  end

  def create
    @comment = Comment.new comment_params
    @comment.author = current_user
    require_logged_in_as @comment.card.list.board.members

    if @comment.save
      # render json: @card, status: :created, location: @card
      render :show
    else
      render json: @card.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit :body, :card_id
  end

  def set_comment
    @comment = Comment.find params[:id]
  end
end
