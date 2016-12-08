class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.string :token
      t.integer :price_per_month

      t.timestamps
    end
  end
end
