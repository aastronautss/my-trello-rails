class Plan
  attr_reader :name, :price_per_month, :stripe_plan_id, :friendly_name

  PLANS = {
    basic: {
      name: 'basic',
      price_per_month: 0,
      stripe_plan_id: 'my_trello_basic',
      friendly_name: 'Basic'
    },

    plus_monthly: {
      name: 'plus_monthly',
      price_per_month: 299,
      stripe_plan_id: 'my_trello_plus_monthly',
      friendly_name: 'Plus'
    }
  }

  def initialize(plan_name)
    plan_info = PLANS[plan_name.to_sym]

    raise ArgumentError, 'Invalid plan name.' unless plan_info

    @name = plan_info[:name]
    @price_per_month = plan_info[:price_per_month]
    @stripe_plan_id = plan_info[:stripe_plan_id]
    @friendly_name = plan_info[:friendly_name]
  end
end
