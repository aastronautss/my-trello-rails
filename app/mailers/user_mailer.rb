class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'My Trello - Account Activation'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'My Tello - Reset Your Password'
  end
end
