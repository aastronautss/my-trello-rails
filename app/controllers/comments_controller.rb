class CommentsController < ApplicationController
  # before_action :set_comment, except: [:new, :create, :index]
  before_action -> { require_user remote: true }
  # before_action -> { require_logged_in_as @comment.board_members, remote: true },
  #   except: [:new, :create, :index]

  def create
    @card = Card.find params[:id]
    return unless require_logged_in_as @card.board_members, remote: true
    params = comment_params

    if @card.add_comment params[:body], current_user
      render template: 'cards/show', status: :ok, location: @card
    else
      render json: @card.errors.full_messages, status: :unprocessable_entity
    end
  end

  # def update
  #   if @comment.update comment_params
  #     render template: 'comments/show', status: :ok, location: @comment
  #   else
  #     render json: @comment.errors.full_messages, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   if @comment.destroy
  #     head :no_content
  #   else
  #     render json: @comment.errors.full_messages, status: :unprocessable_entity
  #   end
  # end

  private

  def comment_params
    params.require(:comment).permit :body
  end

  # def set_comment
  #   @comment = Comment.find params[:id]
  # end
end
