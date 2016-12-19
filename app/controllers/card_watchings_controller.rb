class CardWatchingsController < ActivatedRemoteController
  def create
    @card = Card.find_by token: params[:id]

    return unless require_logged_in_as @card.board_members, remote: true

    if current_user.watch @card
      head :no_content
    else
      render json: ['Action unsuccessful'], status: :unprocessable_entity
    end
  end

  def destroy
    @card = Card.find_by token: params[:id]

    return unless require_logged_in_as @card.board_members, remote: true

    if current_user.unwatch @card
      head :no_content
    else
      render json: ['Action unsuccessful'], status: :unprocessable_entity
    end
  end
end
