class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'My Trello - Account Activation'
  end

  def account_creation_notification(user, creator)
    @user = user
    @creator = creator
    mail to: user.email, subject: 'My Trello - Account Created'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'My Tello - Reset Your Password'
  end

  def password_change_notification(user)
    @user = user
    mail to: user.email, subject: 'My Trello - Password Changed'
  end

  def notify(user, subject, message)
    @user = user
    @message = message

    mail to: user.email, subject: "My Trello: #{subject}"
  end
end
