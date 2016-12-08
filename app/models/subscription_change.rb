class SubscriptionChange
  attr_reader :message

  def initialize(user)
    @user = user
  end

  # BEGGING TO BE REFACTORED
  def change(plan_token, stripe_token)
    plan = Plan.find_by token: plan_token

    if !plan.basic?
      customer = StripeWrapper::Customer.create card: stripe_token,
        user: @user

      if customer.successful?
        @user.stripe_customer_id = customer.id
        subscription = StripeWrapper::Subscription.create plan: plan,
          user: @user

        if subscription.successful?
          @user.plan = plan
          @user.save

          # UserMailer.send_subscription_email(@user)
          @status = :success
        else
          @status = :failure
          @message = subscription.message
        end
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
