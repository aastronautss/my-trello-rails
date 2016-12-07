class SubscriptionChange
  attr_reader :message

  def initialize(user)
    @user = user
  end

  def change(plan_token, stripe_token)
    plan = Plan.find_by token: plan_token

    if !plan.basic?
      customer = StripeWrapper::Customer.create card: stripe_token,
        user: @user
      subscription = StripeWrapper::Subscription.create plan: plan,
        user: @user

      if customer.successful? && subscription.successful?
        @user.update stripe_customer_id: customer.id, plan: plan

        # UserMailer.send_subscription_email(@user)
        @status = :success
      else
        @status = :failure
        @message = customer.message
      end
    else
      @user.update plan: plan
    end

    self
  end

  def successful?
    @status == :success
  end
end
