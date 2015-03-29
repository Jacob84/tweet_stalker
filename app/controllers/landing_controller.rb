# LandingController
class LandingController < ApplicationController
  def index
    app_url = url_for(controller: 'single_page_application', action: 'index')
    redirect_to app_url if logged_in?
  end
end
