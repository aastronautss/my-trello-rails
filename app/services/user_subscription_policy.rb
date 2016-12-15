class UserSubscriptionPolicy
  def initialize(user)
    @user = user
  end

  def basic?
    check_level ['basic', 'plus']
  end

  def plus?
    check_level ['plus']
  end

  private

  def check_level(valid_levels)
    valid_levels.include? @user.plan_object.level
  end
end
