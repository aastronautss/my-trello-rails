class CardsController < ApplicationController
  before_action :set_card, except: [:new, :create]
  before_action :require_user
  before_action -> { require_logged_in_as @card.list.board.members },
                  only: [:show]

  def show
    @comment = Comment.new
  end

  def new
    list = List.find params[:list_id]
    @card = Card.new list: list
    require_logged_in_as list.board.members
  end

  def create
    @card = Card.new card_params
    require_logged_in_as @card.list.board.members

    if @card.save
      flash[:success] = 'Your card was created.'
      redirect_to board_path(@card.list.board)
    else
      render :new
    end
  end

  private

  def card_params
    params.require(:card).permit(:title, :list_id)
  end

  def set_card
    @card = Card.find params[:id]
  end
end
