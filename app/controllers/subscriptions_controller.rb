class SubscriptionsController < ActivatedController
  def create
    user = current_user
    change = SubscriptionHandler.new(user).
      subscribe(params[:plan_id], params[:stripeToken])

    if change.successful?
      flash[:success] = "Thank you for subscribing to the #{user.plan.name} plan!"
    else
      flash[:danger] = "There was a problem processing your request: #{change.message}"
    end

    redirect_to my_account_path
  end
end
