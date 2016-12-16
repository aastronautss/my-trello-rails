class CreateCardWatchings < ActiveRecord::Migration
  def change
    create_table :card_watchings do |t|
      t.integer :card_id
      t.integer :user_id

      t.timestamps
    end
  end
end
