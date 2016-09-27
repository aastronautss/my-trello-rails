class AddPositionToListsAndCards < ActiveRecord::Migration
  def change
    add_column :lists, :position, :integer
    add_column :cards, :position, :integer
  end
end
