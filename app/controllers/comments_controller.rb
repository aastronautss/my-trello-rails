class CommentsController < ApplicationController
  before_action :set_card, only: [:create]
  before_action :require_user

  def index
    board = Board.find params[:board_id]
    require_logged_in_as board.members

    @comments = Comment.joins(card: [list: :board]).
                        where(lists: { board_id: board.id })

    respond_to do |format|
      format.js { render json: @comments }
    end
  end

  def create
    @comment = @card.comments.build comment_params
    require_logged_in_as @card.list.board.members

    if @comment.save
      flash[:success] = 'Your comment has been created.'
      redirect_to card_path(@comment.card)
    else
      render 'cards/show'
    end
  end

  private

  def comment_params
    params.require(:comment).permit :body
  end

  def set_card
    @card = Card.find params[:card_id]
  end

  def set_comment
    @comment = Comment.find params[:id]
  end
end
