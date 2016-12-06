class SubscriptionChange
  def initialize(user)
    @user = user
  end

  def change(plan_token, stripe_token)
    plan = Plan.find_by token: plan_token

    unless plan.basic?
      customer = StripeWrapper::Customer.create card: stripe_token,
        user: @user, plan: plan
    end
  end
end
