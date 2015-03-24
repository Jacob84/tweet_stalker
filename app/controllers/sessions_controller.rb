# SessionsController
class SessionsController < ApplicationController
  def create
    nickname = auth_hash[:info][:nickname]

    user_from_db = ApplicationUser.find_by_nickname(nickname)

    user_from_db = create_new_user if user_from_db.nil?

    log_in user_from_db

    # redirect_to user_from_db

    render nothing: true, status: 200, content_type: 'text/html'
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
        ApplicationUserCredential.new(
          provider: 'twitter',
          token: auth_hash[:credentials][:token],
          secret: auth_hash[:credentials][:secret])
      ])
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
