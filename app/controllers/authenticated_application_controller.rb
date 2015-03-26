class AuthenticatedApplicationController < ApplicationController
  include SessionsHelper
  before_action :test_logged_in, except: [:create]
end
