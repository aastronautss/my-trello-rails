class AddOwnerToBoardRelationships < ActiveRecord::Migration
  def change
    add_column :board_relationships, :owner, :boolean
  end
end
