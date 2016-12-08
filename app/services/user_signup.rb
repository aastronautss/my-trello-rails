class UserSignup
  attr_reader :message

  def initialize(user)
    @user = user
  end

  def sign_up
    if @user.valid?
      handler = SubscriptionHandler.new(@user).subscribe(:basic, nil)

      @status = handler.successful?
      @message = handler.message

      @user.save if successful?
    end

    self
  end

  def successful?
    @status
  end
end
