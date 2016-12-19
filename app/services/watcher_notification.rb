class WatcherNotification
  attr_reader :object, :current_user

  def initialize(object, current_user: nil)
    raise ArgumentError, 'Invalid object.' unless object.respond_to? 'watchers'

    @object = object
    @current_user = current_user
  end

  def notify(subject, message)
    watchers = @current_user.nil? ? @object.watchers : @object.watchers.reject { |user| user.id == @current_user.id }

    watchers.each do |user|
      UserMailer.notify(user, subject, message).deliver_now
    end
  end
end
