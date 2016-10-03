class AddChecklistsToCards < ActiveRecord::Migration
  def change
    add_column :cards, :checklists, :jsonb
    add_index :cards, :checklists, using: :gin
  end
end
