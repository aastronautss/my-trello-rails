class AddDefaultFalseToOwnerInBoardMemberships < ActiveRecord::Migration
  def change
    change_column :board_memberships, :owner, :boolean, default: false
  end
end
