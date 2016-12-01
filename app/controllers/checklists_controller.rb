class ChecklistsController < ActivatedRemoteController
  before_action :set_card

  def create
    if @card.add_checklist checklist_params[:title], current_user
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
end
