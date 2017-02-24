class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :provider, null: false
      t.string :remote_id, null: false
      t.string :token, null: false
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
