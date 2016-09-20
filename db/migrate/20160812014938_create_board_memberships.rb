class CreateBoardMemberships < ActiveRecord::Migration
  def change
    create_table :board_memberships do |t|
      t.integer :user_id
      t.integer :board_id
      t.boolean :admin, default: false

      t.timestamp
    end
  end
end
