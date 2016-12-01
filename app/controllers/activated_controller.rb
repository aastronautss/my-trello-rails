class ActivatedController < ApplicationController
  before_action :require_user
  before_action :require_activated_user

  def require_activated_user(remote: false)
    unless current_user.activated?
      message = 'Your account must be activated to do that.'
      access_denied message, remote: remote
    end
  end
end
