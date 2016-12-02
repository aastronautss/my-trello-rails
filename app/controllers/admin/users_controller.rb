class Admin::UsersController < SystemAdminController
  def index
    @users = User.all
  end
end
