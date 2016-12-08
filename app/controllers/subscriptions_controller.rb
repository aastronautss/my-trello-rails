class SubscriptionsController < ActivatedController
  def create
    user = current_user
    response = SubscriptionHandler.new(user).
      subscribe(params[:plan_id], params[:stripeToken])

    if response.successful?
      flash[:success] = "Thank you for subscribing to the #{user.plan} plan!"
    else
      flash[:danger] = "There was a problem processing your request: #{response.message}"
    end

    redirect_to my_account_path
  end
end
