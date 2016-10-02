class CardsController < ApplicationController
  before_action :set_card, except: [:new, :create, :index]
  before_action -> { require_user remote: true }
  before_action -> { require_logged_in_as @card.board_members, remote: true },
                  only: [:show, :update, :destroy]

  def index
    board = Board.find params[:board_id]
    return unless require_logged_in_as board.members, remote: true

    @cards = Card.joins(list: :board).where(lists: { board_id: board.id })
  end

  def show
  end

  def create
    @card = Card.new card_params
    @card.position = @card.list.next_card_position
    return unless require_logged_in_as @card.board_members, remote: true

    if @card.save
      @card.add_activity 'created this card', current_user
      render template: 'cards/show', status: :created, location: @card
    else
      render json: @card.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @card.update card_params, current_user
      @card.list.normalize_card_positions
      @card.reload
      render template: 'cards/show', status: :ok, location: @card
    else
      render json: @card.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if @card.destroy
      head :no_content
    else
      render json: @card.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def card_params
    params.require(:card).permit(:title, :description, :list_id)
  end

  def set_card
    @card = Card.find params[:id]
  end
end
