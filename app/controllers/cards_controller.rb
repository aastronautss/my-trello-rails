class CardsController < ApplicationController
  before_action :set_card, except: [:new, :create, :index]
  before_action :require_user
  before_action -> { require_logged_in_as @card.list.board.members },
                  only: [:show]

  def index
    board = Board.find params[:board_id]
    @cards = Card.joins(list: :board).where(lists: { board_id: board.id })
    require_logged_in_as board.members

    respond_to do |format|
      format.json { render json: @cards }
    end
  end

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

    respond_to do |format|
      if @card.save
        format.html do
          flash[:success] = 'Your card was created.'
          redirect_to board_path(@card.list.board)
        end
        format.json { render json: @card, status: :created, location: @card}
      else
        format.html { render :new }
        format.json { render json: @card.errors.full_messages,
                        status: :unprocessable_entity }
      end
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
