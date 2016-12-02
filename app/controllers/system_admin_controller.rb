class SystemAdminController < ActivatedController
  before_action :require_system_admin

  def require_system_admin
    access_denied('You do not have access to that area') unless current_user.system_admin?
  end
end
