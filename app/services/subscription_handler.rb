class SubscriptionHandler
  attr_reader :message

  def initialize(user)
    @user = user
  end

  def subscribe(plan_name, stripe_token = nil)
    result = process_stripe_info plan_name, stripe_token

    @status = result[:status]
    @message = result[:message]

    self
  end

  def successful?
    @status == :success
  end

  private

  def process_stripe_info(plan_name, stripe_token)
    customer = StripeWrapper::Customer.create user: @user, stripe_token: stripe_token
    return { status: :failure, message: customer.message } unless customer.successful?
    @user.stripe_customer_id = customer.id

    plan = Plan.new(plan_name)
    subscription = StripeWrapper::Subscription.create user: @user, plan: plan

    return { status: :failure, message: subscription.message } unless subscription.successful?
    @user.stripe_subscription_id = subscription.id
    @user.plan = plan.name
    @user.save

    { status: :success }
  end
end
