class CardsController < ApplicationController
  before_action :set_card, except: [:new, :create, :index]
  before_action :require_user
  before_action -> { require_logged_in_as @card.list.board.members },
                  only: [:show, :update, :destroy]

  def index
    board = Board.find params[:board_id]
    @cards = Card.joins(list: :board).where(lists: { board_id: board.id })
    require_logged_in_as board.members

    render json: @cards
  end

  def show
    @comment = Comment.new
  end

  def create
    @card = Card.new card_params
    require_logged_in_as @card.list.board.members

    if @card.save
      render json: @card, status: :created, location: @card
    else
      render json: @card.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @card.update card_params
      render json: @card, status: :ok, location: @card
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
