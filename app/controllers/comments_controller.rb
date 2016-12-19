class CommentsController < ActivatedRemoteController
  def create
    @card = Card.find_by token: params[:id]
    return unless require_logged_in_as @card.board_members, remote: true
    params = comment_params

    if @card.add_comment params[:body], current_user
      notify_watchers
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

  def notify_watchers
    subject = "New card comment"
    message = "#{current_user.username} has commented on card \"#{@card.title}\"."

    WatcherNotification.new(@card, current_user: current_user).
      notify(subject, message)
  end

  # def set_comment
  #   @comment = Comment.find params[:id]
  # end
end
