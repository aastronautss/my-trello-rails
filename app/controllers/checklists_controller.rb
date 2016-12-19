class ChecklistsController < ActivatedRemoteController
  before_action :set_card

  def create
    if @card.add_checklist checklist_params[:title], current_user
      notify_watchers
      render template: 'cards/show', status: :ok, location: @card
    else
      head :unprocessable_entity
    end
  end

  private

  def set_card
    @card = Card.find_by token: params[:card_id]
  end

  def checklist_params
    params.require(:checklist).permit(:title)
  end

  def notify_watchers
    subject = "Checklist added to card"
    message = "#{current_user.username} has added a checklist to card \"#{@card.title}\"."

    WatcherNotification.new(@card, current_user: current_user).
      notify(subject, message)
  end
end
