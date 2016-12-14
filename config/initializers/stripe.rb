Stripe.api_key = ENV['stripe_api_key']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    data = event.data.object

    user = User.find_by stripe_customer_id: data.customer
    amount = data.amount
    reference_id = data.id

    Payment.create user: user, amount: amount, reference_id: reference_id
  end

  events.subscribe 'charge.failed' do |event|
    user = User.find_by stripe_customer_id: event.data.object.customer
    user.subscribe_to(:basic)
    # UserMailer.send_charge_failed_notification
  end
end
