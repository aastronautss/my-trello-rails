class AddOwnerToBoardMemberships < ActiveRecord::Migration
  def change
    add_column :board_memberships, :owner, :boolean
  end
end
