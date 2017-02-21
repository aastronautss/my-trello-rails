class ServicesController < ActivatedController
  def create
    auth = request.env['omniauth.auth']
    @service = Service.find_or_create_by! remote_id: auth.uid, provider: auth.provider do |service|
      service.token = auth.credentials.token
      service.user = current_user
    end

    flash[:success] = "You have successfully linked your #{auth.provider.capitalize} account!"
    redirect_to my_account_path
  end

  def failure
    flash[:danger] = "Authorization failed for #{auth.provider.capitalize}"
    redirect_to my_account_path
  end
end
