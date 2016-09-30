class AddActivitiesToCards < ActiveRecord::Migration
  def change
    add_column :cards, :activities, :jsonb
    add_index :cards, :activities, using: :gin
  end
end
