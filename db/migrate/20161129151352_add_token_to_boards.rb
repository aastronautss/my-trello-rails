class AddTokenToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :token, :string
    add_index :boards, :token

    Board.all.each do |board|
      board.token = SecureRandom.urlsafe_base64
      board.save
    end
  end
end
