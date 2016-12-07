class AddStripePlanIdToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :stripe_plan_id, :string
  end
end
