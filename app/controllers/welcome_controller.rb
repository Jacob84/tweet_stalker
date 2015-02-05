require 'twitter_list_manager'
require 'twitter_list_analyzer'

class WelcomeController < ApplicationController

  def index
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

end
