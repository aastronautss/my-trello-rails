class UserSubscriptionPolicy
  def initialize(user)
    @user = user
  end

  def plus?
    @user.plan_object.level == 'plus'
  end
end
