class CheckItemsController < ApplicationController
  before_action -> { require_user remote: true }
  before_action :set_card

  def create
    checklist_id = params[:checklist_id].to_i

    if @card.add_check_item check_item_params[:name], checklist_id
      render template: 'cards/show', status: :ok, location: @card
    else
      head :unprocessable_entity
    end
  end

  def destroy
    checklist_id = params[:checklist_id].to_i
    check_item_id = params[:id].to_i

    check_items = @card.checklists[:lists][checklist_id][:check_items]
    check_items.delete_at check_item_id

    if @card.save
      render template: 'cards/show', status: :ok, location: @card
    else
      head :unprocessable_entity
    end
  end

  def toggle
    checklist_id = params[:checklist_id].to_i
    check_item_id = params[:id].to_i

    item = @card.checklists[:lists][checklist_id][:check_items][check_item_id]
    item[:done] = !item[:done]

    if @card.save
      render template: 'cards/show', status: :ok, location: @card
    else
      head :unprocessable_entity
    end
  end

  private

  def set_card
    @card = Card.find params[:card_id]
  end

  def check_item_params
    params.require(:check_item).permit :name
  end
end
