class SessionsController < AuthenticatedApplicationController
  def create
    nickname = auth_hash[:info][:nickname]

    user_from_db = ApplicationUser.find_by_nickname(nickname)

    user_from_db = create_new_user if user_from_db.nil?

    log_in user_from_db

    redirect_to url_for(controller: 'single_page_application', action: 'index')
  end

  def destroy
    logout

    redirect_to '/'
  end

  protected

  def create_new_user
    ApplicationUser.create(
      name: '',
      nickname:     auth_hash[:info][:nickname],
      location:     auth_hash[:info][:location],
      image:        auth_hash[:info][:image],
      description:  auth_hash[:info][:description],
      application_user_credentials: [
        create_new_user_credential
      ])
  end

  def create_new_user_credential
    ApplicationUserCredential.new(
      provider: 'twitter',
      token: auth_hash[:credentials][:token],
      secret: auth_hash[:credentials][:secret])
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
