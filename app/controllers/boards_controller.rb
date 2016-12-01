class BoardsController < ActivatedController
  before_action :set_board, only: [:show]
  before_action -> { require_logged_in_as @board.members }, only: [:show]

  def show
    respond_to do |format|
      format.html
      format.js { render json: @board }
    end
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new board_params

    if @board.save
      @board.add_member current_user, true, true

      flash[:success] = 'Your board was created.'
      redirect_to board_path(@board)
    else
      render :new
    end
  end

  private

  def board_params
    params.require(:board).permit(:name)
  end

  def set_board
    @board = Board.find_by token: params[:id]
  end
end
