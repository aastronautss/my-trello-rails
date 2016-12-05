class Admin::UsersController < SystemAdminController
  before_action :set_user, only: [:destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    @user.generate_temporary_password

    if @user.save
      UserMailer.account_creation_notification(@user, current_user).deliver_now
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def destroy
    @user.destroy
    flash[:info] = 'User successfully deleted.'
    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.find_by username: params[:id]
  end

  def user_params
    params.require(:user).permit :username, :email
  end
end
