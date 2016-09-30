class AddActivitiesToCards < ActiveRecord::Migration
  def change
    add_column :cards, :activities, :jsonb
    add_index :cards, :activities, using: :gin

    Comment.all.each do |comment|
      comment.card.add_comment comment.body, comment.author
    end
  end
end
