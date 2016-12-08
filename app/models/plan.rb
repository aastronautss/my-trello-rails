class Plan
  attr_reader :name, :price_per_month, :stripe_plan_id

  PLANS = {
    basic: {
      name: 'basic',
      price_per_month: 0,
      stripe_plan_id: 'my_trello_basic'
    },

    plus_monthly: {
      name: 'plus_monthly',
      price_per_month: 299,
      stripe_plan_id: 'my_trello_plus_monthly'
    }
  }

  def initialize(plan_name)
    plan_info = PLANS[plan_name.to_sym]

    raise ArgumentError, 'Invalid plan name.' unless plan_info

    @name = plan_info[:name]
    @price_per_month = plan_info[:price_per_month]
    @stripe_plan_id = plan_info[:stripe_plan_id]
  end
end
