class ActivatedRemoteController < ActivatedController
  def require_activated_user
    super(remote: true)
  end

  def require_user
    super(remote: true)
  end
end
