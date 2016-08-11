class CardsController < ApplicationController
  before_action :set_card, except: [:new, :create]

  def show
    @comment = Comment.new
  end

  def new
    @card = Card.new list_id: params[:list_id]
  end

  def create
    @card = Card.new card_params

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
